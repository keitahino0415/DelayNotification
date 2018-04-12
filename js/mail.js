'use strict';

var inbox = require('inbox');

//var nodemailer = require('nodemailer');
//var iconv = require('iconv');
//var conv = new iconv.Iconv("UTF-8", "UTF-8");

const simpleParser = require('mailparser').simpleParser;

var client = inbox.createConnection(false, 'imap.gmail.com', {
    secureConnection: true
    ,auth: {
      user: "mailtestsample2@gmail.com",
      pass: "keita0415",
    }
});

client.on('connect', function() {
    console.log('connected');
    client.openMailbox('INBOX', function(error) {
        if (error) throw error;
    });
});

client.connect();

client.on("new", function(message) {
    console.log('日時:' + message.date);
    console.log('送信者:' + message.from.name + '-' + message.from.address);
    console.log('タイトル:' + message.title);

    var stream = client.createMessageStream(message.UID);
    simpleParser(stream)
        .then(mail=> {
            console.log('本文(HTMLテキスト):' + mail.textAsHtml);
        })
        .catch(err=> {
            console.log(err);
        });

});
