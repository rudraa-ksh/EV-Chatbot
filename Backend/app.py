from flask import Flask, request, jsonify
import spacy
import re

# Initialize Flask app
app = Flask(__name__)

# Load spaCy model
nlp = spacy.load("en_core_web_sm")

# Sample knowledge base
knowledge_base = {
    "not charging": [
        {
            "question": "Are there any lights blinking on the charging station?",
            "yes": "Check the power source and ensure the station is working properly.",
            "no": "Ensure the cable is properly connected to both the car and the charger.",
        },
        {
            "question": "Is the charging cable damaged?",
            "yes": "Replace the cable with a new one.",
            "no": "Try resetting the charging station or the vehicle software.",
        },
    ],
    "low range": [
        {
            "question": "Have you recently updated your vehicle software?",
            "yes": "Check if the update has range optimizations.",
            "no": "Update your vehicle software to the latest version.",
        },
        {
            "question": "Are you using climate control heavily?",
            "yes": "Reduce climate control usage to conserve battery.",
            "no": "Visit a service center to check the battery health.",
        },
    ],
}

def extract_keywords(user_input):
    """Extracts keywords using spaCy and matches them to known issues."""
    doc = nlp(user_input)
    negations = {"no", "not", "never", "refuse"}
    issues = []

    for token in doc:
        if token.text.lower() in negations or token.text.lower() in {"charging", "range", "battery", "power"}:
            issues.append(token.text.lower())
    return " ".join(issues).strip()

def match_issue(extracted_issue):
    """Matches the extracted issue to a known issue in the knowledge base."""
    for issue in knowledge_base.keys():
        if re.search(issue, extracted_issue, re.IGNORECASE):
            return issue
    return None

@app.route('/troubleshoot', methods=['POST'])
def troubleshoot():
    data = request.json
    user_input = data.get('issue', '')
    extracted_issue = extract_keywords(user_input)
    matched_issue = match_issue(extracted_issue)
    
    if matched_issue:
        steps = knowledge_base[matched_issue]
        return jsonify({"issue": matched_issue, "steps": steps})
    else:
        return jsonify({"error": "Issue not recognized. Please provide more details."}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)