use strict;
use warnings;
use Test::More;

BEGIN {
    eval "use Test::Cmd";
    plan skip_all => 'Test::Cmd required' if $@;
    plan skip_all => 'backends required' if(!-s 'thruk_local.conf' and !defined $ENV{'CATALYST_SERVER'});
    plan tests => 56;

    use lib('t');
    require TestUtils;
    import TestUtils;

    use_ok 'Thruk::Controller::login';
    use_ok 'Thruk::Controller::restricted';
}

my $pages = [
    { url => '/thruk/cgi-bin/login.cgi',      like => ['Thruk Monitoring Webinterface', 'loginbutton' ] },
    { url => '/thruk/cgi-bin/restricted.cgi', like => ['OK:'] },
    { url => '/thruk/cgi-bin/login.cgi?logout/thruk/cgi-bin/tac.cgi', 'redirect' => 1, location => 'tac.cgi', like => 'This item has moved' },
    { url => '/thruk/cgi-bin/login.cgi?logout/thruk/cgi-bin/tac.cgi?test=blah', 'redirect' => 1, location => 'tac.cgi', like => 'This item has moved' },
];

for my $url (@{$pages}) {
    my $test = TestUtils::make_test_hash($url);
    TestUtils::test_page(%{$test});
}

TestUtils::test_command({
    cmd   => './script/thruk_auth',
    stdin => '/thruk/',
    like => ['/^\/redirect\/thruk\/cgi\-bin\/login\.cgi$/'],
});

TestUtils::test_command({
    cmd   => './script/thruk_auth',
    stdin => '///____/thruk/startup.html',
    like => ['/^\/pass\/thruk\/startup\.html$/'],
});

TestUtils::test_command({
    cmd   => './script/thruk_auth',
    stdin => '///____/thruk/cgi-bin/tac.cgi',
    like => ['/^\/redirect\/thruk\/cgi\-bin\/login\.cgi\?thruk\/cgi\-bin\/tac\.cgi$/'],
});
