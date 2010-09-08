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

print "THIS WILL DELETE EVERYTHING ON THE TARGET LAB MANAGER SERVER: $server\n\nCTRL-C to avoid this. RETURN to continue with deletion.\n";

<STDIN>;

my @confs = ( $labman->ListConfigurations(1), $labman->ListConfigurations(2) );
for my $conf (@confs) {
  my $id = $conf->{id};
  my $name = $conf->{name};

  if ( $conf->{isDeployed} eq 'true' ) {  
    print "Undeploying config: $name ($id)\n";
    my $ret = $labman->ConfigurationUndeploy($id);
    warn $ret if $ret;
  }

  print "Deleting config: $name ($id)\n";
  my $ret = $labman->ConfigurationDelete($id);
  warn $ret if $ret;
}

my @templates = ( $labman->priv_ListTemplates() );
for my $temp (@templates) {
  next if $temp eq ''; # WTF?
  my $id = $temp->{id};
  my $name = $temp->{name};

  next if $name =~ /^VMwareLM-ServiceVM/; # WTF?

  if ( $temp->{isDeployed} eq 'true' ) {  
    print "Undeploying template: $name ($id)\n";
    my $ret = $labman->priv_TemplatePerformAction($id,2);
    warn $ret if $ret;
  }

  print "Deleting template: $name ($id)\n";
  my $ret = $labman->priv_TemplatePerformAction($id,3);
  warn $ret if $ret;
}
