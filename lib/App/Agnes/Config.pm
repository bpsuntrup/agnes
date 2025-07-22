package App::Agnes::Config;

$App::Agnes::Config::config = {
    db_conn => sub {
        return 'dbi:Pg:dbname=agnes';
    },
    saint => 'agnes',
};

sub new {
    return bless $App::Agnes::Config::config, +shift;
}

1;
