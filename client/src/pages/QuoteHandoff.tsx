import { PageShell, Breadcrumbs } from "@/components/Storefront";
import guide from "@shared/quoteHandoff.json";

export default function QuoteHandoff() {
  return (
    <PageShell>
      <article className="container">
        <Breadcrumbs
          items={[
            { label: "Demo", href: "/demo" },
            { label: "Cleaning quote handoff" },
          ]}
        />
        <header className="page-heading">
          <span className="eyebrow">Cleaning operations / Paper rehearsal</span>
          <h1>{guide.title}</h1>
          <p>{guide.intro}</p>
        </header>
        {guide.cases.map((c, i) => (
          <section key={c.label} className="detail-section">
            <span className="eyebrow">Fictional message {i + 1}</span>
            <h2>{c.label}</h2>
            <blockquote>“{c.message}”</blockquote>
            <p>
              <strong>Owner:</strong> {c.owner}
            </p>
            <p>
              <strong>Next step:</strong> {c.action}
            </p>
            <p>
              <strong>Pass if:</strong> {c.check}
            </p>
          </section>
        ))}
        <section className="detail-section">
          <h2>Try this with your intake process</h2>
          <p>{guide.request}</p>
          <a
            className="button dark"
            href={`mailto:${guide.contact}?subject=${encodeURIComponent(guide.subject)}`}
          >
            Request a free rehearsal
          </a>
          <p>
            Or email {guide.contact}. No enquiry is sent until you send the
            email.
          </p>
          <p>{guide.offer}</p>
        </section>
      </article>
    </PageShell>
  );
}
