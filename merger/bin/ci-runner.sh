
if [ -f /var/lib/cozy/credentials/github-access-key.sh ]; then
  . /var/lib/cozy/credentials/github-access-key.sh
else
  echo 'Did not source /var/lib/cozy/credentials/github-access-key.sh'
fi
bundle install
bundle exec bin/merge mgreensmith/testrepo