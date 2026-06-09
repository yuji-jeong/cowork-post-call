---
name: post-call
description: "After a sales call, pull the meeting transcript and the relevant HubSpot deal to assess deal stage progression, populate deal fields, create a follow-up task, and draft a personalised follow-up email. Confirms with the rep before making any changes."
license: MIT
metadata:
  author: yuji-AIML
  version: "1.0"
  category: post-call
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

- **Firefly connector connected** — Co-work reads transcripts from Firefly directly. If you record on Google Meet, make sure your transcripts are saved to Google Drive first and connect the Google Drive connector instead.
- **HubSpot connector connected** — ensure your HubSpot account has custom properties set up for "Next Steps" and "Pain Points" on deal records before running this skill. If those fields don't exist, create them in HubSpot under Settings → Properties first.
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

Using the attendee name or company from the transcript, search HubSpot for the relevant contact or company record. Retrieve:
- The associated contact and company
- The current deal and its pipeline stage
- Any existing notes or next steps on the deal record

If no matching deal is found, surface this to the rep and ask them to clarify before continuing.

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

Using the transcript and the business context from the Your Business Context section above, populate the following fields on the HubSpot deal card:

- **Next steps** — what was agreed at the end of the call
- **Pain points** — challenges or frustrations the prospect mentioned
- **Key details** — any information relevant to this specific business that could help close the deal later

Do not copy the transcript verbatim. Extract only what is useful and actionable. Write in short, scannable bullet points.

> Note: This step requires "Next Steps" and "Pain Points" to already exist as custom deal properties in HubSpot. See Prerequisites above.

---

## Step 5 — Create a Follow-Up Task in HubSpot

Create a task on the deal record. Set the due date based on the energy and outcome of the call:

- **Real momentum** (strong interest, clear next step agreed, urgency expressed) → due in 2–3 days
- **Positive but cautious** (interested but needs time, no firm commitment) → due in 1–2 weeks
- **Early stage or exploratory** (just getting to know each other, no clear signal either way) → due in 2–3 weeks

Show the rep the proposed due date and your reasoning before creating the task. Adjust if they ask.

> Note: Task creation requires your HubSpot connector to support engagement/task creation. If this step fails, check that your connector has the necessary permissions in HubSpot.

---

## Step 6 — Draft a Follow-Up Email in Gmail

Draft a follow-up email to the main contact from the call. Guidelines:

- Under 150 words
- Warm but direct — no filler phrases like "I hope this email finds you well"
- Reference at least one specific detail from the conversation to make it feel personal
- Include the agreed next step clearly

Show the draft to the rep and make any edits they request. Once approved, save it as a Gmail draft.

**Remind the rep:** Co-work cannot schedule emails to send automatically. The draft will sit in Gmail — send it manually on the date of the HubSpot task due date.

Sign off with the rep's name from the Your Business Context section above.

---

## Important

- Never update the deal stage, create a task, or save an email draft without explicit confirmation from the rep at each step.
- If the transcript is incomplete or ambiguous, flag this clearly rather than making assumptions.
- Always refer to the Your Business Context section above when deciding what details to capture.
