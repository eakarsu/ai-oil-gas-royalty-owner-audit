// Feature pack: search/filter, CSV/JSON export, deterministic offline AI insights.
// No provider calls: every insight is computed from the app's own records and
// labelled aiGenerated:false so it is never mistaken for model output.
export function filterRecords(rows, { q = "", status = "", risk = "", state = "", owner = "" } = {}) {
  const needle = String(q).trim().toLowerCase();
  return (rows || []).filter((row) => {
    if (status && String(row.status ?? "") !== status) return false;
    if (state && String(row.state ?? "") !== state) return false;
    if (risk && String(row.risk ?? "") !== risk) return false;
    if (owner && String(row.owner ?? "") !== owner) return false;
    if (!needle) return true;
    return Object.values(row ?? {}).some((v) => v != null && String(typeof v === "object" ? JSON.stringify(v) : v).toLowerCase().includes(needle));
  });
}
function csvCell(v) {
  if (v === null || v === undefined) return "";
  const s = typeof v === "object" ? JSON.stringify(v) : String(v);
  return /[",\n\r]/.test(s) ? '"' + s.replace(/"/g, '""') + '"' : s;
}
export function recordsToCsv(rows) {
  const list = rows || [];
  if (!list.length) return "";
  const headers = Object.keys(list[0]);
  return [headers.map(csvCell).join(","), ...list.map((r) => headers.map((h) => csvCell(r[h])).join(","))].join("\n");
}
export function exportRecords(rows, format = "json") {
  const list = rows || [];
  if (String(format).toLowerCase() === "csv") return { contentType: "text/csv; charset=utf-8", filename: "records.csv", body: recordsToCsv(list) };
  return { contentType: "application/json; charset=utf-8", filename: "records.json", body: JSON.stringify({ items: list, count: list.length }, null, 2) };
}
const num = (v) => { const n = Number(v); return Number.isFinite(n) ? n : 0; };
export function buildInsights(rows, labels) {
  const list = rows || [];
  const total = list.reduce((s, r) => s + num(r.amount), 0);
  const high = list.filter((r) => ["High", "Critical"].includes(String(r.risk ?? "")));
  const open = list.filter((r) => !["Approved", "Closed", "closed", "approved"].includes(String(r.status ?? r.state ?? "")));
  const overdue = list.filter((r) => r.due_date && String(r.due_date).slice(0, 10) < new Date().toISOString().slice(0, 10) && open.includes(r));
  const mk = (id, title, summary, metrics) => ({
    id, title, aiGenerated: false, source: "deterministic-fallback",
    label: "Deterministic offline insight (not AI-generated)",
    summary, metrics,
    sections: [
      { title: "Finding", detail: summary },
      { title: "Evidence", detail: list.length ? `${list.length} record(s) reviewed; ${high.length} high/critical; ${open.length} open; ${overdue.length} overdue; total value ${total}.` : "No records available; counts are 0 and lists are empty." },
      { title: "Next action", detail: open.length ? "Assign an accountable owner, validate source evidence, and record the disposition." : "No open records require action." },
    ],
  });
  return [
    mk("risk-concentration", labels[0], high.length ? `${high.length} of ${list.length} record(s) are High/Critical risk.` : "No High/Critical risk records in the current set.", [{ label: "Records reviewed", value: list.length }, { label: "High/Critical", value: high.length }, { label: "Total value", value: total }]),
    mk("ageing-exceptions", labels[1], overdue.length ? `${overdue.length} open record(s) are past due.` : "No overdue open records in the current set.", [{ label: "Open records", value: open.length }, { label: "Overdue open", value: overdue.length }, { label: "Empty result preserved", value: false }]),
    mk("recovery-pipeline", labels[2], open.length ? `${open.length} open record(s) represent ${open.reduce((s, r) => s + num(r.amount), 0)} of pipeline value.` : "Pipeline is empty (0 open records, value 0).", [{ label: "Open records", value: open.length }, { label: "Pipeline value", value: open.reduce((s, r) => s + num(r.amount), 0) }, { label: "Closed excluded", value: list.length - open.length }]),
  ];
}
