use strict;
use Test::More 0.98;

use t::Util;
use Queue::Gearman;

plan skip_all => 'cannot find gearmand.' unless has_gearmand();

my @gearmandes;
my @servers;
for (1) {#for (1..3) {
    my $gearmand = setup_gearmand();
    my $server   = sprintf 'localhost:%d', $gearmand->port;
    push @gearmandes => $gearmand;
    push @servers    => $server;
}

my $queue = Queue::Gearman->new(
    servers            => \@servers,
    serialize_method   => sub { join ',', @{$_[0]} },
    deserialize_method => sub { [split /,/, $_[0]] },
);
isa_ok $queue, 'Queue::Gearman';
$queue->can_do('add');

subtest 'dequeue: no job' => sub {
    my $job = $queue->dequeue();
    is $job, undef, 'no job';
};

subtest 'enqueue_forground: complete' => sub {
    my $task = $queue->enqueue_forground(add => [1, 2]);
    isa_ok $task, 'Queue::Gearman::Task';

    my $job = $queue->dequeue();
    isa_ok $job, 'Queue::Gearman::Job';
    is $job->func, 'add', 'func: add';
    is_deeply $job->arg, [1, 2], 'arg: 1,2';
    $job->complete([3]);

    $task->wait();

    ok !$task->fail, 'not failed';
    is_deeply $task->result, [3],    'result: 3';
};

subtest 'enqueue_forground: fail' => sub {
    my $task = $queue->enqueue_forground(add => [1, 'str']);
    isa_ok $task, 'Queue::Gearman::Task';

    my $job = $queue->dequeue();
    isa_ok $job, 'Queue::Gearman::Job';
    is $job->func, 'add', 'func: add';
    is_deeply $job->arg, [1, 'str'], 'arg: 1,str';
    $job->fail();

    $task->wait();

    ok $task->fail, 'task failed';
};

subtest 'enqueue_background' => sub {
    my $task = $queue->enqueue_background(add => [1, 2]);
    isa_ok $task, 'Queue::Gearman::Task';

    my $job = $queue->dequeue();
    isa_ok $job, 'Queue::Gearman::Job';
    is $job->func, 'add', 'func: add';
    is_deeply $job->arg, [1, 2], 'arg: 1,2';
    $job->complete([]);
};

done_testing;
