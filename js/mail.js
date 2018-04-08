var emailTrigger = require("email-trigger");

emailTrigger({
  user: "mailtestsample2@gmail.com",
  pass: "keita0415",
  host: "imap.gmail.com"
}, function(mail) {
  console.log(mail);
});
