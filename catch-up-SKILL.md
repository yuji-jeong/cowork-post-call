---
name: catch-up
description: "Morning briefing skill. Surfaces HubSpot tasks due today, Gmail drafts ready to send, at-risk deals, urgent incoming emails, and today's meetings — all in one place."
license: MIT
metadata:
  author: yuji-jeong
  version: "1.0"
  category: daily-routine
---

# Catch-Up Skill

Run this at the start of your day. Pulls everything that needs your attention into one summary so you know exactly where to focus before you open anything else.

## Prerequisites

- **HubSpot connector connected** — to read tasks and deals
- **Gmail connector connected** — to read drafts and inbox
- **Google Calendar connector connected** — to read today's meetings (this is a separate connector from Gmail; make sure it is connected in Co-work settings)

---

## Step 1 — Gmail Drafts vs. HubSpot Tasks

Check Gmail for unsent draft emails **created in the last 7 days only**. Ignore anything older — those are not relevant to current deals.

For each recent draft, cross-reference against open HubSpot tasks to find a matching follow-up task for that contact or deal:

**If a matching HubSpot task is found:**
- Due today or overdue → flag as **ready to send** and ask the rep if they would like to send it now
- Due in the future → list it but do not surface it as urgent

**If no matching HubSpot task is found:**
- Look up the recipient in HubSpot and check deal activity from the past 7 days (notes, logged meetings, last contact)
- If recent activity is found that suggests a follow-up is expected, surface the draft with a brief note on what was found and ask the rep if they would like to send it now
- If no relevant activity is found, silently ignore the draft — do not surface it

For each surfaced draft show:
- Recipient name and email
- Subject line
- Matching HubSpot task due date (if found), or a one-line summary of recent deal activity (if no task)

When asking whether to send, wait for explicit confirmation before sending. Do not send automatically.

> **Note on sending:** This skill will offer to send the email immediately on confirmation. Verify that your Gmail connector supports sending (not just drafting) in Co-work before relying on this step.

> **Heads up:** This step works best when `/post-call` was run after each meeting — it creates the HubSpot task and Gmail draft together, so `/catch-up` can always match them up. Make it a habit: run `/post-call` after every call and `/catch-up` will know exactly what needs to go out and when.

> **Connector note:** Both Gmail and HubSpot connectors must be active for cross-referencing to work. If only Gmail is connected, recent drafts will be listed without task matching.

---

## Step 2 — HubSpot Tasks Due Today

Pull all HubSpot tasks assigned to you with a due date of today. List them with:
- Task name
- Associated deal or contact
- Due date

If there are no tasks due today, say so clearly.

---

## Step 3 — At-Risk Deals

Scan open HubSpot deals and flag any that look at risk. A deal is at risk if any of the following are true:
- No activity logged in the past 14 days
- An overdue task (due date has passed, task is still open)
- Deal stage has not moved in 30 or more days

For each flagged deal, show:
- Deal name and current stage
- Why it was flagged (no activity / overdue task / stale stage)
- Days since last activity or last stage change

---

## Step 4 — Urgent Emails in Inbox

Scan emails that arrived since the end of the previous business day. Flag any that appear urgent or need a reply today based on:
- Sender is a known contact or prospect from HubSpot
- Subject or content suggests a time-sensitive request, question, or decision
- Any email marked high priority by the sender

For each flagged email, show:
- Sender name
- Subject
- One-sentence summary of what they need

If nothing urgent is found, say so.

---

## Step 5 — Today's Meetings

List all meetings scheduled for today from Google Calendar with:
- Meeting title
- Time and duration
- Attendees (if visible)

List them in chronological order.

---

## Format

Keep the output concise and scannable. Use clear section headers for each step. This is a morning briefing, not a detailed report — the goal is to give a full picture in under two minutes of reading.

---

## Important

- If the Google Calendar connector is not connected, skip Step 5 and note that meetings could not be retrieved.
- If HubSpot returns no tasks or deals, say so — do not skip the section silently.
- Do not make any changes to HubSpot, Gmail, or Calendar. This skill is read-only.
