#!/usr/bin/perl

use Data::Dumper;
use VMware::API::LabManager;
use strict;

my $version = ( split ' ', '$Revision: 1.1 $' )[1];

### Configuration

my $username  = 'sbo-migration';
my $password  = 'welcome1';
my $orgname   = 'Global';
my $workspace = 'Main';
my $server    = '10.198.138.73';

my $labman = new VMware::API::LabManager (
  $username,        # Username
  $password,        # Password
  $server,          # Server
  $orgname,         # Org Name
  $workspace        # Workspace Name
);

my $networks = $labman->priv_ListNetworks();
print Dumper($networks);
