---
name: catch-up
description: "Morning briefing skill. Surfaces HubSpot tasks due today, Gmail drafts ready to send, at-risk deals, urgent incoming emails, and today's meetings — all in one place."
license: MIT
metadata:
  author: yuji-jeong
  version: "1.0"
  category: daily-routine
  recommended_model: claude-haiku-4-5 
---

# Catch-Up Skill

Run this at the start of your day. Pulls everything that needs your attention into one summary so you know exactly where to focus before you open anything else.

## Prerequisites

- **Recommended model: Claude Haiku 4.5** — this skill is a read-only morning briefing with rule-based flagging. No deal stage judgment calls. Haiku is fast and efficient for this routine.
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

For each surfaced draft, capture the thread ID to build a direct Gmail link (`https://mail.google.com/mail/u/0/#drafts/{threadId}`).

For each surfaced draft show:
- Recipient name (as a clickable link that opens the draft directly in Gmail)
- Subject line
- Matching HubSpot task due date (if found), or a one-line summary of recent deal activity (if no task)

When asking whether to send, wait for explicit confirmation before sending. Do not send automatically.

> **Note on sending:** This skill will offer to send the email immediately on confirmation. Verify that your Gmail connector supports sending (not just drafting) in Co-work before relying on this step.

> **Heads up:** This step works best when `/post-call` was run after each meeting — it creates the HubSpot task and Gmail draft together, so `/catch-up` can always match them up. Make it a habit: run `/post-call` after every call and `/catch-up` will know exactly what needs to go out and when.

> **Connector note:** Both Gmail and HubSpot connectors must be active for cross-referencing to work. If only Gmail is connected, recent drafts will be listed without task matching.

---

## Step 2 — HubSpot Tasks Due Today

Pull all HubSpot tasks assigned to you with a due date of today. For each task, capture the task ID and the HubSpot portal ID — these are used to build a direct link to the task in HubSpot (`https://app.hubspot.com/tasks/{portalId}/view/all/task/{taskId}`).

Before listing, cross-reference against any emails that were sent in Step 1. If a task was associated with a draft that the rep confirmed sending, mark it as already handled and surface it separately with a note — do not list it as outstanding:

> "✓ Follow-up email to [Name] — already sent this morning."

For all remaining tasks, list them with:
- Task name (as a clickable link to the task in HubSpot)
- Associated deal or contact
- Due date

If all tasks due today were handled in Step 1, say so clearly. If there are no tasks due today at all, say so clearly.

---

## Step 3 — At-Risk Deals

Scan open HubSpot deals and flag any that look at risk. A deal is at risk if any of the following are true:
- No activity logged in the past 14 days
- An overdue task (due date has passed, task is still open)
- Deal stage has not moved in 30 or more days

For each flagged deal, capture the deal ID and portal ID to build a direct link (`https://app.hubspot.com/contacts/{portalId}/record/0-3/{dealId}`).

For each flagged deal, show:
- Deal name (as a clickable link to the deal in HubSpot) and current stage
- Why it was flagged (no activity / overdue task / stale stage)
- Days since last activity or last stage change

---

## Step 4 — Urgent Emails & Respond

Scan emails that arrived since the end of the previous business day. Flag any that appear urgent or need a reply today based on:
- Sender is a known contact or prospect from HubSpot
- Subject or content suggests a time-sensitive request, question, or decision
- Any email marked high priority by the sender

For each flagged email, capture the thread ID to build a direct Gmail link (`https://mail.google.com/mail/u/0/#inbox/{threadId}`).

For each flagged email, show:
- Sender name (as a clickable link that opens the email directly in Gmail)
- Subject
- One-sentence summary of what they need

After listing all flagged emails, ask the rep: "Would you like to draft a reply to any of these?" If yes, draft a reply for each one they specify — keep it concise, reference the context from HubSpot if available, and save as a Gmail draft for review before sending.

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

Output a self-contained HTML file named `morning-briefing.html`. Do not output markdown — the entire response should be the HTML file contents.

The HTML must:
- Use `Syne` (display/body) and `Space Mono` (monospace metadata) from Google Fonts
- Dark background `#09090b`, card surface `#111116`, thin borders `#1c1c22`
- Five cards in order: Gmail Drafts → Tasks Due Today → At-Risk Deals → Urgent Emails → Today's Meetings
- Summary pills in the header showing counts at a glance (ready to send, overdue, at-risk, meetings)
- Status badges: **Ready to Send** (green), **Overdue** (red), **At Risk** (amber), **Handled** (gray), **Reply Needed** (blue)
- Due dates in `Space Mono`, coloured red if overdue, amber if today
- Meetings section as a vertical timeline (time → dot → title + attendees)
- Staggered `fadeUp` entrance animation on cards
- Footer showing generation time and "HigherOps · Co-work"
- Empty state message inside the card if a section has nothing to show

Follow the structure and visual design of `catch-up-template.html` exactly — replace placeholder data with real data from HubSpot, Gmail, and Google Calendar.

---

## Step 6 — Action Menu

After saving the HTML file, print the following directly in the chat — plain text, no markdown formatting:

List only the items that need action today, numbered:
- Gmail drafts that are **Ready to Send** (due today)
- Urgent emails that need a reply
- Overdue HubSpot tasks (ask if the rep wants to mark any as done)

Example format:
```
Here's what I can action for you:

[1] Send email to Alex Rivera — "Great connecting today — next steps"
[2] Draft reply to Jordan Kim (Clearpath Digital) — Proposal feedback
[3] Mark overdue tasks as done (3 tasks — Pinewave Technologies & Streamline Inc)

What would you like me to handle? (e.g. "do 1 and 2", "all", or "skip")
```

Wait for the rep's response before doing anything. Once confirmed, execute only the items they selected — in order, one at a time. Confirm each one after it's done before moving to the next.

If there is nothing to action, say: "Nothing needs action right now. Have a great day."

---

## Important

- If the Google Calendar connector is not connected, skip Step 5 and note that meetings could not be retrieved.
- If HubSpot returns no tasks or deals, say so — do not skip the section silently.
- Steps 1–5 are read-only. Only Step 6 makes changes, and only after explicit confirmation from the rep.
