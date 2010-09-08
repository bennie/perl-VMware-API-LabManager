#!/usr/bin/perl

use Data::Dumper;
use VMware::API::LabManager;
use strict;

my $version = ( split ' ', '$Revision: 1.1 $' )[1];

### Configuration

my $username  = 'ppollard';
my $password  = 'z2A3p464';
my $orgname   = 'Global';
my $workspace = 'Main';
my $server    = '10.198.138.73'; # Source

my $labman = new VMware::API::LabManager (
  $username,        # Username
  $password,        # Password
  $server,          # Server
  $orgname,         # Org Name
  $workspace        # Workspace Name
);

my $configs = $labman->ListConfigurations(1);
my $config = $configs->[0];

my $machines = $labman->ListMachines($config->{id});

print Dumper($machines);
