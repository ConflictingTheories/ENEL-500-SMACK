function send_mail_message(emailto,subject,counter,attachment)
%% SEND_MAIL_MESSAGE send email to gmail once calculation is done
% Example
% send_mail_message('its.neeraj','Simulation finished')
 
% Pradyumna
% June 2008
%Modified by Hamid Shaker, June 2014
%Modified by Shane Fast, August 2014
%       -message and attachment enhancements made, diary file sent for
%       runtime error reviewing.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Your gmail ID and password 
%(from which email ID you would like to send the mail)
mail = 'NWP.run@gmail.com';    %Your GMail email address
password = 'hamidhamed';          %Your GMail password
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set up Gmail SMTP service.
% Then this code will set up the preferences properly:
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username','NWP.run');
setpref('Internet','SMTP_Password',password);

% Gmail server.
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

%% Send the email
if strcmp(mail,'GmailId@gmail.com')
    disp('Please provide your own gmail.')
    disp('You can do that by modifying the first two lines of the code')
    disp('after the comments.')
end

if counter
    message = sprintf('please view the runtime report for further details. files completed: %d.\n\nRuntime reports viewable in Matlab or in Notepad. All runtime report are stored on the master computer under Desktop/NWP/runtime_logs',counter);
    sendmail(emailto,subject,message,attachment)
else
    sendmail(emailto,subject)
end
end