# encoding: utf-8
require 'browser_test_helper'

class TwitterBrowserTest < TestCase
  def test_add_config

    # app config
    if !ENV['TWITTER_CONSUMER_KEY']
      fail "ERROR: Need TWITTER_CONSUMER_KEY - hint TWITTER_CONSUMER_KEY='1234'"
    end
    consumer_key = ENV['TWITTER_CONSUMER_KEY']
    if !ENV['TWITTER_CONSUMER_SECRET']
      fail "ERROR: Need TWITTER_CONSUMER_SECRET - hint TWITTER_CONSUMER_SECRET='1234'"
    end
    consumer_secret = ENV['TWITTER_CONSUMER_SECRET']

    if !ENV['TWITTER_USER_LOGIN']
      fail "ERROR: Need TWITTER_USER_LOGIN - hint TWITTER_USER_LOGIN='1234'"
    end
    twitter_user_login = ENV['TWITTER_USER_LOGIN']

    if !ENV['TWITTER_USER_PW']
      fail "ERROR: Need TWITTER_USER_PW - hint TWITTER_USER_PW='1234'"
    end
    twitter_user_pw = ENV['TWITTER_USER_PW']

    if !ENV['TWITTER_CUSTOMER_TOKEN']
      fail "ERROR: Need TWITTER_CUSTOMER_TOKEN - hint TWITTER_CUSTOMER_TOKEN='1234'"
    end
    twitter_customer_token = ENV['TWITTER_CUSTOMER_TOKEN']

    if !ENV['TWITTER_CUSTOMER_TOKEN_SECRET']
      fail "ERROR: Need TWITTER_CUSTOMER_TOKEN_SECRET - hint TWITTER_CUSTOMER_TOKEN_SECRET='1234'"
    end
    twitter_customer_token_secret = ENV['TWITTER_CUSTOMER_TOKEN_SECRET']

    hash  = "#sweetcheck#{rand(99_999)}"

    @browser = browser_instance
    login(
      username: 'master@example.com',
      password: 'test',
      url: browser_url,
      auto_wizard: true,
    )
    tasks_close_all()

    click(css: 'a[href="#manage"]')
    click(css: 'a[href="#channels/twitter"]')
    click(css: '#content .js-configApp')
    sleep 2
    set(
      css: '#content .modal [name=consumer_key]',
      value: consumer_key,
    )
    set(
      css: '#content .modal [name=consumer_secret]',
      value: 'wrong',
    )
    click(css: '#content .modal .js-submit')

    watch_for(
      css: '#content .modal .alert',
      value: 'Authorization Required',
    )

    set(
      css: '#content .modal [name=consumer_secret]',
      value: consumer_secret,
    )
    click(css: '#content .modal .js-submit')

    watch_for_disappear(
      css: '#content .modal .alert',
      value: 'Authorization Required',
    )

    watch_for(
      css: '#content .js-new',
      value: 'add account',
    )

    click(css: '#content .js-configApp')

    set(
      css: '#content .modal [name=consumer_secret]',
      value: 'wrong',
    )
    click(css: '#content .modal .js-submit')

    watch_for(
      css: '#content .modal .alert',
      value: 'Authorization Required',
    )

    set(
      css: '#content .modal [name=consumer_secret]',
      value: consumer_secret,
    )
    click(css: '#content .modal .js-submit')

    watch_for_disappear(
      css: '#content .modal .alert',
      value: 'Authorization Required',
    )

    watch_for(
      css: '#content .js-new',
      value: 'add account',
    )

    click(css: '#content .js-new')

    sleep 10

    set(
      css: '#username_or_email',
      value: twitter_user_login,
      no_click: true, # <label> other element would receive the click
    )
    set(
      css: '#password',
      value: twitter_user_pw,
      no_click: true, # <label> other element would receive the click
    )
    click(css: '#allow')

    #watch_for(
    #  css: '.notice.callback',
    #  value: 'Redirecting you back to the application',
    #)

    watch_for(
      css: '#content .modal',
      value: 'Search Terms',
    )

    # add hash tag to search
    click(css: '#content .modal .js-searchTermAdd')
    set(css: '#content .modal [name="search::term"]', value: hash)
    select(css: '#content .modal [name="search::group_id"]', value: 'Users')
    click(css: '#content .modal .js-submit')
    sleep 5

    watch_for(
      css: '#content',
      value: 'Bob Mutschler',
    )
    watch_for(
      css: '#content',
      value: "@#{twitter_user_login}",
    )
    exists(
      css: '#content .main .action:nth-child(1)'
    )
    exists_not(
      css: '#content .main .action:nth-child(2)'
    )

    # add account again
    click(css: '#content .js-new')

    sleep 10

    click(css: '#allow')

    watch_for(
      css: '#content .modal',
      value: 'Search Terms',
    )

    click(css: '#content .modal .js-close')

    watch_for(
      css: '#content',
      value: 'Bob Mutschler',
    )
    watch_for(
      css: '#content',
      value: "@#{twitter_user_login}",
    )
    exists(
      css: '#content .main .action:nth-child(1)'
    )
    exists_not(
      css: '#content .main .action:nth-child(2)'
    )

    # start tweet from customer
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = consumer_key
      config.consumer_secret     = consumer_secret
      config.access_token        = twitter_customer_token
      config.access_token_secret = twitter_customer_token_secret
    end

    text  = "Today... #{hash}"
    tweet = client.update(
      text,
    )

    # watch till tweet is in app

    # reply via app

    # watch till tweet reached customer

  end

end
