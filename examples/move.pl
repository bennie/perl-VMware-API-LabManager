#!/usr/bin/perl

use Data::Dumper;
use VMware::API::LabManager;
use strict;

my $version = ( split ' ', '$Revision: 1.1 $' )[1];

### Configuration

my $username  = 'migration';
my $password  = 'welcome1';
my $server    = '10.207.251.54'; # Prod source

my $orgname   = 'Global';
my $workspace = 'Main';

my $labman = new VMware::API::LabManager (
  $username,        # Username
  $password,        # Password
  $server,          # Server
  $orgname,         # Org Name
  $workspace        # Workspace Name
);

my $org_id = 3; # SSL
my $start_workspace  = 9;  # Main
my $finish_workspace = 14; # Archive

my $configs = $labman->GetConfigurationByName('aaa test');
my $config = $configs->[0];

my $id     = $config->{id};
my $name   = $config->{name};

my $machines = $labman->ListMachines($id);
my @machineids;

for my $machine (@$machines) {
  push @machineids, $machine->{id};
}

print "Working with '$name' ($id)\n";

my $ret = $labman->priv_ConfigurationMove(
  $id,
  $finish_workspace,
  'true',
  $name,  
  $config->{description},
  $config->{autoDeleteInMilliSeconds},
  undef, #$id,
  \@machineids,
  'true'
);

if ( $ret =~ /^\d+$/ ) {
  print "Worked: $ret\n";
} else {
  print $labman->{ConfigurationMove}->{_context}->{_transport}->{_proxy}->{_http_response}->{_request}->{_content};
  print Dumper($ret);
}
