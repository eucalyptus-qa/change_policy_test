#!/usr/bin/perl
use strict;
use Cwd;

require "./lib_for_euare.pl";
require "./lib_for_euare_policy.pl";
require "./lib_for_euare_teardown.pl";

require "./lib_for_euare_policy_02.pl";
require "./lib_for_euare_list.pl";

$ENV{'EUCALYPTUS'} = "/opt/eucalyptus";


###
### check for arguments
###

my $given_account_name = "";
my $given_user_name = "";
my $given_policy_name = "";

if ( @ARGV > 0 ){
	$given_account_name = shift @ARGV;
};

if ( @ARGV > 0 ){
	$given_user_name = shift @ARGV;
};

if ( @ARGV > 0 ){
	$given_policy_name = shift @ARGV;
};



################################################## SETUP POLICY TEST ACCOUNT . PL #########################################################


print "\n";
print "########################### READ INPUT FILE  ##############################\n";

read_input_file();

my $clc_ip = $ENV{'QA_CLC_IP'};
my $source_lst = $ENV{'QA_SOURCE'};

if( $clc_ip eq "" ){
	print "[ERROR]\tCouldn't find CLC's IP !\n";
	exit(1);
};

if( $source_lst eq "PACKAGE" || $source_lst eq "REPO" ){
        $ENV{'EUCALYPTUS'} = "";
};



###
### check account name
###

print "\n";
print "########################### ACCOUNT INFORMATION  ##############################\n";

my $account_name = "euare-policy-test-account";
my $group_name = "group00";
my $user_name = "user00";
my $policy_name = "fullaccess.policy";

my $group_count = 3;
my $user_count = 3;

if( $given_account_name ne "" ){
	$account_name = $given_account_name;
};

if( $given_user_name ne "" ){
	$user_name = $given_user_name;
};

if( $given_policy_name ne "" ){
	$policy_name = $given_policy_name;
};


print "\n";
print "TEST ACCOUNT NAME [$account_name]\n";
print "TEST GROUP NAME [$group_name]\n";
print "TEST USER NAME [$user_name]\n";
print "TEST POLICY NAME [$policy_name]\n";
print "\n";
print "TEST GROUP COUNT [$group_count]\n";
print "TEST USER COUNT [$user_count]\n";
print "\n";
print "\n";


print "\n";
print "\n";
print "\n";


print "\n";
print "+++++++++++++++++++++++++++++++++++++++++++++++++++ Alter the Policy of Test Target +++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";

print "\n";
print "\n";
print "\n";


###
### assign 'fullaccess' policy to 'user00'
###
copy_given_policy_file($policy_name);
set_account_user_policy($account_name, $user_name, $policy_name);
print "\n";

print "\n";
print "\n";
print "\n";


print "\n";
print "+++++++++++++++++++++++++++++++++++++++++++++++++++ Verify the Policy of Test Target +++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";

print "\n";
print "\n";
print "\n";

my $failed = 0;

###
### list all user policies
###
my $list = list_all_user_policies_given_account_and_user_and_target_user($account_name, "admin", $user_name);
print "\n";

print "list_all_user_policies_given_account_and_user_and_target_group(\"$account_name\", \"admin\", \"$user_name\"):\n";
print "$list\n";
print "\n";

if( !($list =~ /$policy_name/m) ){
	print "[TEST_REPORT]\tFAILED in adding policy to user !!\n\n";
	$failed = 1;
};

print "\n";
print "\n";
print "\n";

print "\n";
print "+++++++++++++++++++++++++++++++++++++++++++++++++++ Summarize the Change +++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";


###
### Summarize the Change
###

if( $failed ){
	print "\n";
	print "[TEST_REPORT]\tFAILED in ALTER POLICY of TEST TARGET\n";
	print "\n";
	exit(1);
};

print "Created Account: $account_name\n";

print "\n";

print "Assigned \'$policy_name\' to User \'$user_name\'\n";
print "\n";

print "\n";
print "\n";
print "\n";

###
### End of Script
###

print "\n";
print "[TEST_REPORT]\tALTER POLICY OF TEST TARGET HAS BEEN COMPLETED\n";
print "\n";

exit(0);

1;


