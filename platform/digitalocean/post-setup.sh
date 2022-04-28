curl https://raw.githubusercontent.com/digitalocean/marketplace-partners/master/scripts/90-cleanup.sh | bash -

rm -f /var/log/auth.log

curl https://raw.githubusercontent.com/digitalocean/marketplace-partners/master/scripts/99-img-check.sh | bash -

exit 0
