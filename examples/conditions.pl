#!/usr/bin/perl

use Data::Dumper;
use VMware::API::LabManager;
use strict;

my $version = ( split ' ', '$Revision: 1.1 $' )[1];

### Configuration

my $username  = 'migration';
my $password  = 'welcome1';
my $server    = '10.207.251.54';

my $orgname   = 'Global';
my $workspace = 'Main';

my $labman = new VMware::API::LabManager (
  $username,        # Username
  $password,        # Password
  $server,          # Server
  $orgname,         # Org Name
  $workspace        # Workspace Name
);

my $cond = $labman->priv_GetObjectConditions(4,794);

print Dumper($cond);
