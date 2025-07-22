use Mojolicious::Lite -signatures;

get '/' => sub ($c) {
    $c->render(text => 'almost there');
};

post '/login' => sub ($c) {

};

app->start;
