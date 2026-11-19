CREATE TABLE "dodo_events" (
	"id" text PRIMARY KEY NOT NULL,
	"type" text NOT NULL,
	"processedAt" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dodo_product_map" (
	"automationId" text PRIMARY KEY NOT NULL,
	"dodoProductId" text NOT NULL,
	"createdAt" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE "growth_activities" (
	"id" text PRIMARY KEY NOT NULL,
	"leadId" text NOT NULL,
	"agent" text NOT NULL,
	"channel" text NOT NULL,
	"subject" text,
	"content" text NOT NULL,
	"outcome" text,
	"meta" text,
	"createdAt" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE "growth_leads" (
	"id" text PRIMARY KEY NOT NULL,
	"nicheId" text NOT NULL,
	"businessName" text NOT NULL,
	"ownerName" text,
	"website" text,
	"phone" text,
	"email" text,
	"whatsapp" text,
	"instagram" text,
	"city" text,
	"country" text DEFAULT 'India',
	"sourceName" text,
	"sourceUrl" text,
	"assessment" text,
	"opportunityScore" integer DEFAULT 0 NOT NULL,
	"priority" text DEFAULT 'warm' NOT NULL,
	"pitchAngle" text,
	"status" text DEFAULT 'new' NOT NULL,
	"doNotContact" boolean DEFAULT false NOT NULL,
	"doNotContactReason" text,
	"lastContactedAt" timestamp with time zone,
	"nextContactAt" timestamp with time zone,
	"notes" text,
	"createdAt" timestamp with time zone NOT NULL,
	"updatedAt" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE "marketing_events" (
	"id" serial PRIMARY KEY NOT NULL,
	"type" text NOT NULL,
	"path" text,
	"referrer" text,
	"sessionId" text,
	"meta" text,
	"createdAt" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE "newsletter_subscribers" (
	"id" text PRIMARY KEY NOT NULL,
	"email" text NOT NULL,
	"source" text DEFAULT 'website' NOT NULL,
	"name" text,
	"verified" integer DEFAULT 0 NOT NULL,
	"unsubscribedAt" timestamp with time zone,
	"createdAt" timestamp with time zone NOT NULL,
	CONSTRAINT "newsletter_subscribers_email_unique" UNIQUE("email")
);
--> statement-breakpoint
CREATE TABLE "onboarding_requests" (
	"id" text PRIMARY KEY NOT NULL,
	"userId" integer,
	"businessName" text,
	"website" text,
	"email" text,
	"categoryId" text NOT NULL,
	"answers" text,
	"delivery" text,
	"planId" text,
	"status" text DEFAULT 'new' NOT NULL,
	"createdAt" timestamp with time zone NOT NULL,
	"updatedAt" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE "promo_codes" (
	"code" text PRIMARY KEY NOT NULL,
	"kind" text NOT NULL,
	"value" integer NOT NULL,
	"active" integer DEFAULT 1 NOT NULL,
	"usageLimit" integer,
	"usedCount" integer DEFAULT 0 NOT NULL,
	"note" text,
	"createdAt" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE "store_inquiries" (
	"id" text PRIMARY KEY NOT NULL,
	"reference" text NOT NULL,
	"name" text NOT NULL,
	"email" text NOT NULL,
	"business" text NOT NULL,
	"industry" text NOT NULL,
	"automation" text NOT NULL,
	"supportOption" text,
	"location" text,
	"country" text,
	"timezone" text,
	"languages" text,
	"ownerRole" text,
	"apiProviders" text,
	"tools" text NOT NULL,
	"goals" text NOT NULL,
	"phone" text,
	"website" text,
	"consent" integer DEFAULT 1 NOT NULL,
	"createdAt" timestamp with time zone NOT NULL,
	CONSTRAINT "store_inquiries_reference_unique" UNIQUE("reference")
);
--> statement-breakpoint
CREATE TABLE "store_orders" (
	"id" text PRIMARY KEY NOT NULL,
	"userId" integer NOT NULL,
	"items" text NOT NULL,
	"amount" integer NOT NULL,
	"currency" text DEFAULT 'USD' NOT NULL,
	"status" text DEFAULT 'pending' NOT NULL,
	"gateway" text DEFAULT 'stripe' NOT NULL,
	"customerName" text,
	"customerEmail" text,
	"promoCode" text,
	"stripeSessionId" text,
	"stripeCustomerId" text,
	"stripePaymentIntentId" text,
	"dodoCheckoutId" text,
	"dodoPaymentId" text,
	"dodoCustomerId" text,
	"dodoSubscriptionId" text,
	"createdAt" timestamp with time zone NOT NULL,
	"updatedAt" timestamp with time zone NOT NULL,
	CONSTRAINT "store_orders_stripeSessionId_unique" UNIQUE("stripeSessionId"),
	CONSTRAINT "store_orders_dodoCheckoutId_unique" UNIQUE("dodoCheckoutId")
);
--> statement-breakpoint
CREATE TABLE "store_purchases" (
	"id" text PRIMARY KEY NOT NULL,
	"orderId" text NOT NULL,
	"userId" integer NOT NULL,
	"items" text NOT NULL,
	"createdAt" timestamp with time zone NOT NULL,
	CONSTRAINT "store_purchases_orderId_unique" UNIQUE("orderId")
);
--> statement-breakpoint
CREATE TABLE "store_subscriptions" (
	"id" text PRIMARY KEY NOT NULL,
	"userId" integer NOT NULL,
	"planId" text NOT NULL,
	"status" text DEFAULT 'pending' NOT NULL,
	"gateway" text DEFAULT 'dodo' NOT NULL,
	"customerEmail" text,
	"dodoSubscriptionId" text,
	"dodoCustomerId" text,
	"dodoProductId" text,
	"nextBillingDate" timestamp with time zone,
	"createdAt" timestamp with time zone NOT NULL,
	"updatedAt" timestamp with time zone NOT NULL,
	CONSTRAINT "store_subscriptions_dodoSubscriptionId_unique" UNIQUE("dodoSubscriptionId")
);
--> statement-breakpoint
CREATE TABLE "stripe_events" (
	"id" text PRIMARY KEY NOT NULL,
	"type" text NOT NULL,
	"processedAt" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE "users" (
	"id" serial PRIMARY KEY NOT NULL,
	"openId" text NOT NULL,
	"name" text,
	"email" text,
	"passwordHash" text,
	"loginMethod" text,
	"role" text DEFAULT 'user' NOT NULL,
	"createdAt" timestamp with time zone NOT NULL,
	"updatedAt" timestamp with time zone NOT NULL,
	"lastSignedIn" timestamp with time zone NOT NULL,
	CONSTRAINT "users_openId_unique" UNIQUE("openId")
);
--> statement-breakpoint
CREATE UNIQUE INDEX "store_subscriptions_user_plan" ON "store_subscriptions" USING btree ("userId","planId");