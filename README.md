# NAME

Queue::Gearman - Queue interface for Gearman.

# SYNOPSIS

    use Queue::Gearman;

    my $queue = Queue::Gearman->new(servers => ['127.0.0.1:6667']);
    $queue->can_do('Foo');

    $queue->enqueue(Foo => '{"args":{"foo":"bar"}}');

    my $job = $queue->dequeue(timeout => 1);
    if ($job->func eq 'Foo') {
        my $args = decode_json $job->arg;
        my $res  = eval { Foo->work($args) };
        if (my $e = $@) {
            $job->fail(encode_json $e);
        }
        else {
            $job->complete(encode_json $res);
        }
    }

# DESCRIPTION

Queue::Gearman is ...

# LICENSE

Copyright (C) karupanerura.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

karupanerura <karupa@cpan.org>
