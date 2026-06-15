---
name: post-call
description: "After a sales call, pull the meeting transcript and the relevant HubSpot deal to assess deal stage progression, populate deal fields, create a follow-up task, and draft a personalised follow-up email. Confirms with the rep before making any changes."
license: MIT
metadata:
  author: yuji-jeong
  version: "1.0"
  category: post-call
  recommended_model: claude-sonnet-4-6
---

# Post-Call Skill

After a sales call, handle all post-call admin in one place — deal stage check, CRM field population, follow-up task, and a personalised email draft. Always confirm before changing anything in HubSpot.

---

## Your Business Context

> Fill in this section before using the skill. Claude will use this to decide what details from a call are worth saving in your CRM.

**Company description** *(1–2 sentences about what your company does and who you sell to)*
[e.g. We provide cloud-based accounting software for small business owners in Canada.]

**Product or service**
[e.g. Subscription software / professional consulting / physical product]

**Details worth capturing from a call** *(what information about a prospect could help close the deal later?)*
[e.g. Company size, current tools they use, budget range, decision timeline, key objections, who else is involved in the decision]

**Your name** *(used to sign off follow-up emails)*
[e.g. Yuji]

---

## Prerequisites

- **Recommended model: Claude Sonnet 4.6** — this skill involves reading transcripts, assessing deal stage progression, and making judgment calls on timing and content. A more capable model produces noticeably better results here. Use Sonnet 4.6 or above.
- **Firefly connector connected** — Co-work reads transcripts from Firefly directly. If you record on Google Meet, make sure your transcripts are saved to Google Drive first and connect the Google Drive connector instead.
- **HubSpot connector connected** — the skill writes to two deal properties: **Next Steps** (default HubSpot property, already exists) and **Pain Points** (custom deal property — add this in HubSpot under Settings → Properties → Deals before running the skill).
- **Gmail connector connected**

---

## Step 1 — Pull the Transcript

Retrieve the most recent meeting transcript from Firefly. Identify:
- The names of attendees
- The company or organisation they represent
- Key topics discussed

If no transcript is found, let the rep know and stop. Do not proceed without a transcript.

---

## Step 2 — Find the Deal in HubSpot

From the transcript, extract the company name and/or the email domain of the attendees. Search the HubSpot deal board for any deal with a matching or similar company name.

**If a matching deal is found:**
- Retrieve the current pipeline stage
- Retrieve any existing notes or next steps on the deal record
- Proceed to Step 3

**If no matching deal is found:**
- Search HubSpot for the company record (HubSpot typically creates this automatically after a meeting). Use whichever already exists — do not create a duplicate.
- Create a new deal and attach the existing company record to it
- If no company record exists either, let the rep know and ask them to confirm before proceeding

Do not search for contacts or companies as a first step — always check the deal board first.

---

## Step 3 — Assess Deal Stage Progression

Read the transcript and look for signals that indicate the deal has moved forward:

- Budget confirmed or range discussed
- Decision-maker identified or introduced
- Timeline or urgency established
- Agreement to a next step (demo, proposal, contract review)
- Objections resolved
- Explicit buying intent expressed

Compare these signals against the current deal stage. Assess whether the evidence supports moving the deal to the next stage.

Present your reasoning to the rep before making any changes:
- Current deal stage
- Signals from the transcript that suggest progression
- Proposed new stage (if applicable)
- Any gaps or uncertainties

Ask: "Based on this call, I'd recommend moving the deal from [current stage] to [next stage]. Does this look right to you?"

Only update the deal stage after the rep confirms. If they decline, make no changes.

---

## Step 4 — Populate Deal Fields

Using the transcript and the business context from the Your Business Context section above, populate the following deal properties on the HubSpot deal card:

- **Next Steps** *(deal property)* — what was agreed at the end of the call. Format as dashes, one per line:
  ```
  - Agreed to a follow-up demo next Tuesday
  - Rep to send pricing breakdown by Thursday
  ```
- **Pain Points** *(deal property)* — challenges or frustrations the prospect mentioned. Format as dashes, one per line:
  ```
  - Current tool takes too long to onboard new reps
  - No visibility into deal activity across the team
  ```
- **Key details** — any additional information relevant to this specific business that could help close the deal later

Do not copy the transcript verbatim. Extract only what is useful and actionable. Keep each line short and scannable.

> Note: Next Steps is a default HubSpot deal property. Pain Points must be added as a custom deal property before this step will work — see Prerequisites above.

---

## Step 5 — Create a Follow-Up Task in HubSpot

Before creating the task, retrieve the HubSpot owner ID to assign the task:
1. Call `get_user_details` to get the current user's HubSpot owner ID.
2. If that fails or returns no owner ID, call `search_owners` with email `yujijeongdata@gmail.com` to find the owner ID.
3. Always set `ownerId` (or the equivalent assignee field) on the task to this owner ID. **Never create a task without an assignee** — unassigned tasks do not surface in the deal board task view.

Create a task on the deal record. Set the due date based on the energy and outcome of the call:

- **Real momentum** (strong interest, clear next step agreed, urgency expressed) → due in 2–3 days
- **Positive but cautious** (interested but needs time, no firm commitment) → due in 1–2 weeks
- **Early stage or exploratory** (just getting to know each other, no clear signal either way) → due in 2–3 weeks

In the task notes, summarise the key points from the call using dashes as bullets, one per line:
```
- Prospect confirmed budget of ~$5k/month
- Decision timeline is end of Q3
- Follow-up demo agreed for next Tuesday
```

Show the rep the proposed due date, task notes, and your reasoning before creating the task. Adjust if they ask.

> Note: Task creation requires your HubSpot connector to support engagement/task creation. If this step fails, check that your connector has the necessary permissions in HubSpot.

---

## Step 6 — Draft a Follow-Up Email in Gmail

Draft a follow-up email to the main contact from the call. Guidelines:

- Under 150 words
- Warm but direct — no filler phrases like "I hope this email finds you well"
- Reference at least one specific detail from the conversation to make it feel personal
- Include the agreed next step clearly

Show the draft to the rep and make any edits they request. Once approved, save it as a Gmail draft and then mark it as unread — this keeps it visible in the inbox as a reminder to review and send.

**Remind the rep:** Co-work cannot schedule emails to send automatically. The draft will sit in Gmail marked as unread — send it manually on the date of the HubSpot task due date.

Sign off with the rep's name from the Your Business Context section above.

---

## Important

- Never update the deal stage, create a task, or save an email draft without explicit confirmation from the rep at each step.
- If the transcript is incomplete or ambiguous, flag this clearly rather than making assumptions.
- Always refer to the Your Business Context section above when deciding what details to capture.
