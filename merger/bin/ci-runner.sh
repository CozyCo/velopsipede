
if [ -f /var/lib/cozy/credentials/github-access-key.sh ]; then
  . /var/lib/cozy/credentials/github-access-key.sh
else
  echo 'Did not source /var/lib/cozy/credentials/github-access-key.sh'
fi

if [ -f /var/lib/cozy/credentials/slack-token.sh ]; then
  . /var/lib/cozy/credentials/slack-token.sh
else
  echo 'Did not source /var/lib/cozy/credentials/slack-token.sh'
fi
bundle install
bundle exec bin/merge CozyCo/marketing-jekyll

bundle exec slack-post -s cozy -r marketing -m "The velopsipede has fired! Marketing production deploy is imminent!!"