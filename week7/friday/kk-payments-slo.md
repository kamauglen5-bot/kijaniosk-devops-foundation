# kk-payments SLI/SLO Definitions

## Availability SLI
- Measures: % of successful HTTP responses from /health endpoint
- Source: nginx access via http://127.0.0.1/health
- Window: 30 days rolling
- Formula: (successful requests / total requests) * 100

SLO:
- Target: 99.9% availability over 30 days

Rollback Threshold:
- < 99% availability in 5-minute window triggers rollback

---

## Latency SLI
- Measures: response time of /health endpoint
- Source: curl timing or nginx logs
- Window: 30 days rolling
- Formula: average response time

SLO:
- Target: < 200ms average response

Rollback Threshold:
- > 500ms average over 2 minutes triggers rollback

---

## Error Rate SLI
- Measures: % of failed HTTP responses (5xx/timeout)
- Source: nginx logs
- Window: 30 days rolling

SLO:
- Target: < 1% error rate

Rollback Threshold:
- > 5% errors in 2 minutes triggers rollback

---

## What we do NOT commit to
- External network latency (ISP or internet issues)
- Client-side performance (browser/device issues)
