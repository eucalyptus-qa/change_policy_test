#!/usr/bin/perl
use strict;
use Cwd;

require "./lib_for_euare.pl";
require "./lib_for_euare_policy.pl";
require "./lib_for_euare_teardown.pl";

require "./lib_for_euare_policy_02.pl";
require "./lib_for_euare_list.pl";

$ENV{'EUCALYPTUS'} = "/opt/eucalyptus";


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
my $group_name = "group";
my $user_name = "user";

my $group_count = 3;
my $user_count = 3;


print "\n";
print "TEST ACCOUNT NAME [$account_name]\n";
print "TEST GROUP NAME [$group_name]\n";
print "TEST USER NAME [$user_name]\n";
print "\n";
print "TEST GROUP COUNT [$group_count]\n";
print "TEST USER COUNT [$user_count]\n";
print "\n";
print "\n";



###
### clean up all the pre-existing credentials
###

print "\n";
print "########################### CLEAN UP CREDENTIALS  ##############################\n";

print "\n";
print("ssh -o StrictHostKeyChecking=no root\@$clc_ip \"cd /root; rm -f *_cred.zip; rm -fr /root/cred_depot/eucalyptus/admin; rm -fr /root/cred_depot/$account_name\"\n");
system("ssh -o StrictHostKeyChecking=no root\@$clc_ip \"cd /root; rm -f *_cred.zip; rm -fr /root/cred_depot/eucalytpus/admin; rm -fr /root/cred_depot/$account_name\" ");


###
### create admin credentials first
###

my $count = 1;
while( $count > 0 ){
	if( get_user_credentials("eucalyptus", "admin") == 0 ){
		$count = 0;
	}else{
		print "Trial $count\tCould Not Create Admin Credentials\n";
		$count++;
		if( $count > 60 ){
			print "[TEST_REPORT]\tFAILED to Create Admin Credentials !!!\n";
			exit(1);
		};
		sleep(1);
	};
};
print "\n";


###
### move the admin credentials on /root/admin_cred of CLC machine
###

unzip_cred_on_clc("eucalyptus", "admin");
print "\n";


print "\n";
print "\n";
print "\n";


print "\n";
print "+++++++++++++++++++++++++++++++++++++++++++++++++++ Setup the Policy Test Account +++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";

print "\n";
print "\n";
print "\n";


###
### remove account
###

if( remove_account($account_name) ){
	print "\n";
	print "[TEST_REPORT]\tFAILED in removing account $account_name !!\n\n";
	exit(1);
};


###
### create account
###

create_account($account_name);
print "\n";


###
### create test account crdentials
###

$count = 1;
while( $count > 0 ){
	if( get_user_credentials($account_name, "admin") == 0 ){
		$count = 0;
	}else{
		print "Trial $count\tCould Not Create Account \'$account_name\' Credentials\n";
		$count++;
		if( $count > 60 ){
			print "[TEST_REPORT]\tFAILED to Create Account \'$account_name\' Credentials !!!\n";
			exit(1);
		};
		sleep(1);
	};
};
print "\n";


###
### move the account credentials on /root/account_cred of CLC machine
###

unzip_cred_on_clc($account_name, "admin");
print "\n";
print "\n";



###
### create 3 users
###

for( my $i=0; $i<$user_count; $i++ ){
	my $this_user = $user_name . sprintf("%02d", $i);
	create_account_user($account_name, $this_user);
	print "\n";
};
print "\n";


###
### create 3 groups
###

for( my $i=0; $i<$group_count; $i++ ){
	my $this_group = $group_name . sprintf("%02d", $i);
	create_account_group($account_name, $this_group);
	print "\n";
};
print "\n";


###
### assign 'fullaccess' policy to 'user01'
###
copy_given_policy_file("fullaccess.policy");
set_account_user_policy($account_name, "user01", "fullaccess.policy");
print "\n";


###
### assign 'fullaccess' policy to 'group01'
###
set_account_group_policy($account_name, "group01", "fullaccess.policy");
print "\n";


###
### add 'user00' to 'group00'
###
set_account_user_to_group($account_name, "user00", "group00");
print "\n";


###
### add 'user02' to 'group01'
###
set_account_user_to_group($account_name, "user02", "group01");
print "\n";


print "\n";
print "\n";
print "\n";


print "\n";
print "+++++++++++++++++++++++++++++++++++++++++++++++++++ Verify the Policy Test Account Setup +++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";

print "\n";
print "\n";
print "\n";

my $failed = 0;

###
### list all accounts
###
my $list = list_all_accounts_given_account_and_user("eucalyptus", "admin");
print "\n";

print "list_all_accounts_given_account_and_user(\"eucalyptus\", \"admin\"):\n";
print "$list\n";
print "\n";

if( !($list =~ /^$account_name/m) ){
	print "[TEST_REPORT]\tFAILED in creating account $account_name !!\n\n";
	$failed = 1;
};


###
### list all groups
###
$list = list_all_groups_given_account_and_user($account_name, "admin");
print "\n";

print "list_all_groups_given_account_and_user(\"$account_name\", \"admin\"):\n";
print "$list\n";
print "\n";

if( !($list =~ /group\/group02/m) ){
	print "[TEST_REPORT]\tFAILED in creating groups !!\n\n";
	$failed = 1;
};


###
### list all users
###
$list = list_all_users_given_account_and_user($account_name, "admin");
print "\n";

print "list_all_users_given_account_and_user(\"$account_name\", \"admin\"):\n";
print "$list\n";
print "\n";

if( !($list =~ /user\/user02/m) ){
	print "[TEST_REPORT]\tFAILED in creating users !!\n\n";
	$failed = 1;
};


###
### list all group policies
###
$list = list_all_group_policies_given_account_and_user_and_target_group($account_name, "admin", "group01");
print "\n";

print "list_all_group_policies_given_account_and_user_and_target_group(\"$account_name\", \"admin\", \"group01\"):\n";
print "$list\n";
print "\n";

if( !($list =~ /fullaccess\.policy/m) ){
	print "[TEST_REPORT]\tFAILED in adding policy to group !!\n\n";
	$failed = 1;
};


###
### list all user policies
###
$list = list_all_user_policies_given_account_and_user_and_target_user($account_name, "admin", "user01");
print "\n";

print "list_all_user_policies_given_account_and_user_and_target_group(\"$account_name\", \"admin\", \"user01\"):\n";
print "$list\n";
print "\n";

if( !($list =~ /fullaccess\.policy/m) ){
	print "[TEST_REPORT]\tFAILED in adding policy to user !!\n\n";
	$failed = 1;
};


###
### list all users in group00
###
$list = list_all_users_in_group_given_account_and_user_and_target_group($account_name, "admin", "group00");
print "\n";

print "list_all_users_in_group_given_account_and_user_and_target_group(\"$account_name\", \"admin\", \"group00\"):\n";
print "$list\n";
print "\n";

if( !($list =~ /user\/user00/m) ){
	print "[TEST_REPORT]\tFAILED in listig users in group00 !!\n\n";
	$failed = 1;
};

###
### list all users in group01
###
$list = list_all_users_in_group_given_account_and_user_and_target_group($account_name, "admin", "group01");
print "\n";

print "list_all_users_in_group_given_account_and_user_and_target_group(\"$account_name\", \"admin\", \"group01\"):\n";
print "$list\n";
print "\n";

if( !($list =~ /user\/user02/m) ){
	print "[TEST_REPORT]\tFAILED in listig users in group01 !!\n\n";
	$failed = 1;
};


###
### list all groups in user
###
$list = list_all_groups_in_user_given_account_and_user_and_target_user($account_name, "admin", "user00");
print "\n";

print "list_all_groups_in_user_given_account_and_user_and_target_user(\"$account_name\", \"admin\", \"user00\"):\n";
print "$list\n";
print "\n";

if( !($list =~ /group\/group00/m) ){
	print "[TEST_REPORT]\tFAILED in listing groups in user00 !!\n\n";
	$failed = 1;
};

###
### list all groups in user02
###
$list = list_all_groups_in_user_given_account_and_user_and_target_user($account_name, "admin", "user02");
print "\n";

print "list_all_groups_in_user_given_account_and_user_and_target_user(\"$account_name\", \"admin\", \"user02\"):\n";
print "$list\n";
print "\n";

if( !($list =~ /group\/group01/m) ){
	print "[TEST_REPORT]\tFAILED in listing groups in user02 !!\n\n";
	$failed = 1;
};

print "\n";
print "\n";
print "\n";

print "\n";
print "+++++++++++++++++++++++++++++++++++++++++++++++++++ Summarize the Policy Test Account +++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";


###
### Summarize the Setup
###

if( $failed ){
	print "\n";
	print "[TEST_REPORT]\tFAILED in SETUP POLICY TEST ACCOUNT\n";
	print "\n";
	exit(1);
};

print "Created Account: $account_name\n";

print "Created $group_count Groups: [ ";
for( my $i=0; $i<$group_count; $i++){
	print "group" . sprintf("%02d", $i), " ";
};
print "]\n";

print "Created $user_count Users: [ ";
for( my $i=0; $i<$user_count; $i++){
	print "user" . sprintf("%02d", $i), " ";
};
print "]\n";

print "\n";

print "Assigned \'fullaccess.policy\' to User \'user01\'\n";
print "\n";

print "Assigned \'fullaccess.policy\' to Group \'group01\'\n";
print "\n";

print "Added User \'user00\' to Group \'group00\'\n";
print "\n";

print "Added User \'user02\' to Group \'group01\'\n";
print "\n";

print "\n";
print "\n";
print "\n";

###
### End of Script
###

print "\n";
print "[TEST_REPORT]\tSETUP POLICY TEST ACCOUNT HAS BEEN COMPLETED\n";
print "\n";

exit(0);

1;


