_ = require "lodash"
console.log _.unique ['id', 'first-name', 'last-name', 
  'email-address', 'headline', "industry", 
  "skills", "certifications", "educations", 
  "courses", "volunteer", "honors-awards", 
  "recommendations-received", "num-recommenders", 
  "three-current-positions", "three-past-positions", 
  "site-standard-profile-request", "picture-url", 
  "positions", "specialties", "summary",
  "location:(name)", "location:(country:(code))",
  "public-profile-url", "associations",
  "interests", "publications", "patents", 
  "languages", "job-bookmarks", "suggestions",
  "date-of-birth", "member-url-resources"
  ]