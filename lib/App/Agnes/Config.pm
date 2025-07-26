package App::Agnes::Config;

$App::Agnes::Config::config = {
    db_conn => sub {
        return 'dbi:Pg:dbname=agnes' , '', '', {
            quote_names => 1
        };
    },
    saint => 'agnes',
};

sub new {
    return bless $App::Agnes::Config::config, +shift;
}

1;
