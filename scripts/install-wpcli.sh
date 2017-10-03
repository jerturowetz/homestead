#!/usr/bin/env bash

echo "install wp cli here"

# WP-CLI Install
install-update-wp-cli() {

    local exists_wpcli

    # Remove old wp-cli symlink, if it exists.
    if [[ -L "/usr/local/bin/wp" ]]; then
        echo "Removing old wp-cli"
        rm -f /usr/local/bin/wp
    fi

    exists_wpcli="$(which wp)"

    if [[ "/usr/local/bin/wp" != "${exists_wpcli}" ]];
    then
        echo 'wp cli doesnt exist'
        #echo -e "Downloading wp-cli, see http://wp-cli.org"
        #sudo curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli-nightly.phar
        #sudo chmod +x wp-cli-nightly.phar
        #sudo mv wp-cli-nightly.phar /usr/local/bin/wp

        # Install bash completions
        #sudo curl -s https://raw.githubusercontent.com/wp-cli/wp-cli/master/utils/wp-completion.bash -o /srv/config/wp-cli/wp-completion.bash
    else
        echo -e "Updating wp-cli..."
        sudo wp --allow-root cli update --nightly --yes
    fi

}
