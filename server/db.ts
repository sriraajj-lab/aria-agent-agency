import { eq } from "drizzle-orm";
import { drizzle } from "drizzle-orm/node-postgres";
import { migrate } from "drizzle-orm/node-postgres/migrator";
import pg from "pg";
import path from "node:path";
import {
  dodoEvents,
  dodoProductMap,
  growthActivities,
  growthLeads,
  marketingEvents,
  newsletterSubscribers,
  onboardingRequests,
  promoCodes,
  storeInquiries,
  storeOrders,
  storePurchases,
  storeSubscriptions,
  stripeEvents,
  users,
  type InsertUser,
} from "../drizzle/schema";
import { ENV } from "./_core/env";

export type AriaDatabase = ReturnType<typeof drizzle>;

let _db: AriaDatabase | null = null;

// Lazily create the drizzle instance so local tooling can run without a DB.
export async function getDb(): Promise<AriaDatabase | null> {
  const url = process.env.DATABASE_URL;
  if (!_db && url && url !== "disabled") {
    try {
      const client = new pg.Pool({ connectionString: url, max: 5 });
      await migrate(drizzle(client), {
        migrationsFolder: path.resolve(process.cwd(), "drizzle", "pg"),
      });
      _db = drizzle({ client, schema: {
        users,
        storeOrders,
        storePurchases,
        storeInquiries,
        stripeEvents,
        dodoEvents,
        storeSubscriptions,
        newsletterSubscribers,
        marketingEvents,
        promoCodes,
        dodoProductMap,
        onboardingRequests,
        growthLeads,
        growthActivities,
      } });
    } catch (error) {
      console.warn("[Database] Failed to connect:", error);
      _db = null;
    }
  }
  return _db;
}

export async function upsertUser(user: InsertUser): Promise<void> {
  if (!user.openId) {
    throw new Error("User openId is required for upsert");
  }

  const db = await getDb();
  if (!db) {
    throw new Error("Database is not available");
  }

  try {
    const values: InsertUser = {
      openId: user.openId,
    };
    const updateSet: Record<string, unknown> = {};

    const textFields = ["name", "email", "loginMethod"] as const;
    type TextField = (typeof textFields)[number];

    const assignNullable = (field: TextField) => {
      const value = user[field];
      if (value === undefined) return;
      const normalized = value ?? null;
      values[field] = normalized;
      updateSet[field] = normalized;
    };

    textFields.forEach(assignNullable);

    // Built-in email accounts only: stored on insert, never updated silently.
    if (user.passwordHash !== undefined && user.passwordHash !== null) {
      values.passwordHash = user.passwordHash;
    }

    if (user.lastSignedIn !== undefined) {
      values.lastSignedIn = user.lastSignedIn;
      updateSet[fieldSafe("lastSignedIn")] = user.lastSignedIn;
    }
    if (user.role !== undefined) {
      values.role = user.role;
      updateSet[fieldSafe("role")] = user.role;
    } else if (user.openId === ENV.ownerOpenId) {
      values.role = "admin";
      updateSet[fieldSafe("role")] = "admin";
    }

    if (!values.lastSignedIn) {
      values.lastSignedIn = new Date();
    }

    if (Object.keys(updateSet).length === 0) {
      updateSet[fieldSafe("lastSignedIn")] = new Date();
    }

    await db
      .insert(users)
      .values(values)
      .onConflictDoUpdate({
        target: users.openId,
        set: updateSet,
      });
  } catch (error) {
    console.error("[Database] Failed to upsert user:", error);
    throw error;
  }
}

// Small helper keeps the updateSet keys type-safe without repeating casts.
function fieldSafe<K extends keyof InsertUser>(key: K): K {
  return key;
}

export async function getUserByOpenId(openId: string) {
  const db = await getDb();
  if (!db) {
    console.warn("[Database] Cannot get user: database not available");
    return undefined;
  }

  const result = await db
    .select()
    .from(users)
    .where(eq(users.openId, openId))
    .limit(1);

  return result.length > 0 ? result[0] : undefined;
}

export async function getUserByEmail(email: string) {
  const db = await getDb();
  if (!db) return undefined;
  const result = await db
    .select()
    .from(users)
    .where(eq(users.email, email.toLowerCase()))
    .limit(1);
  return result.length > 0 ? result[0] : undefined;
}

// TODO: add feature queries here as your schema grows.
