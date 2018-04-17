//'use strict';

var inbox = require('inbox');
var iconv = require('iconv');
var conv = new iconv.Iconv("ISO-2022-JP", "UTF-8");

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


client.on("new", function(message) {
  var tmp = [];

    // console.log('日時:' + message.date);
    // console.log('送信者:' + message.from.name + '-' + message.from.address);
    // console.log('タイトル:' + message.title);
    // console.log('type:' + message.type);

    //ruby実行
    const exec = require('child_process').exec;
    exec('source ../shell/open.sh', (err, stdout, stderr) => {
      if (err) { console.log(err); }
      console.log(stdout);
    });
  // 　console.log(message)

  client.createMessageStream(message.UID).on("data", function(data){
     var body = conv.convert(data).toString();
        });

});
client.connect();
