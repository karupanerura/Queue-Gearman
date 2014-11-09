package Queue::Gearman;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";



1;
__END__

=encoding utf-8

=head1 NAME

Queue::Gearman - Queue interface for Gearman.

=head1 SYNOPSIS

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

=head1 DESCRIPTION

Queue::Gearman is ...

=head1 LICENSE

Copyright (C) karupanerura.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

karupanerura E<lt>karupa@cpan.orgE<gt>

=cut

