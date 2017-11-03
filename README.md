# docker-phptt
Docker images for phptt (php test tools)

## What is phptt

phptt aims to follow PHP versions listed in http://gcov.php.net/ . Those PHP versions target git branches in php source code repository (https://github.com/php/php-src/branches and http://php.net/git.php) instead of released (http://www.php.net/downloads.php) or tagged ones (i.e. https://downloads.php.net/~pollita/).

phptt updates all its Docker images via a cron job which is run via Travis CI that is configured in GitHub repository. That cron job runs at least once a day automatically. This way, as long as you maintain your phptt binary updated in your machine (executing `phptt update`), you'll be at most one day late with latest PHP versions.

## What is the differences between phptt and herdphp/phpqa?

herdphp/phpqa tries to follow PHP versions that are released or tagged versions of PHP plus master/HEAD. The issue is that there's no automatic process providing every day upgraded Docker images. Because of this you can pass a longer time unsynced with new PHP versions until a person process new Docker images and notice users.
