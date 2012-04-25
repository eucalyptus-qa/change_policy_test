#!/usr/bin/perl
use strict;
use Cwd;

$ENV{'EUCALYPTUS'} = "/opt/eucalyptus";

###
### check for arguments
###

my $given_test_name = "";
my $given_account_name = "";
my $given_user_name = "";
my $given_repeat_limit = 0;

if ( @ARGV > 0 ){
	$given_test_name = shift @ARGV;
};

if ( @ARGV > 0 ){
	$given_account_name = shift @ARGV;
};

if ( @ARGV > 0 ){
	$given_user_name = shift @ARGV;
};

if ( @ARGV > 0 ){
	my $temp = shift @ARGV;
	if( $temp =~ /(\d+)/ ){
		$given_repeat_limit = $1;
	};
};


###
### check for testname, account, user, and repeat limit option
###

print "\n";
print "########################### GET ACCOUNT AND USER NAME  ##############################\n";

my $orig_test = "dan_test_dev_as_user";
my $account_name = "default-qa-account";
my $user_name = "user00";
my $repeat_limit = 0;

###
### Default account is the name of this test
###

my $temp_buf = `cat ../*.conf | grep TEST_NAME`;
chomp($temp_buf);
if( $temp_buf =~ /TEST_NAME\s+(.+)/ ){
	$account_name = $1;
	$account_name =~ s/\r//g;
};


if( $given_test_name ne "" ){
	$orig_test = $given_test_name;
};

if( $given_account_name ne "" ){
	$account_name = $given_account_name;
};

if( $given_user_name ne "" ){
	$user_name = $given_user_name;
};

if( $given_repeat_limit > 0 ){
	$repeat_limit = $given_repeat_limit;
};

print "\n";
print "TEST NAME [$orig_test]\n";
print "TEST ACCOUNT NAME [$account_name]\n";
print "TEST USER NAME [$user_name]\n";
if( $repeat_limit > 0 ){
	print "REPEAT LIMIT [$repeat_limit]\n";
};
print "\n";

###
### Prepare Test for Account and User
###

print "\n";
print "++++++++++++++++++++++++++++++++++++ Running \"prep_test_run_as_user.pl\" ++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";

print "\n";
if( $repeat_limit > 0){
	print "perl ./prep_test_run_as_user.pl $orig_test $account_name $user_name $repeat_limit\n";
	system("perl ./prep_test_run_as_user.pl $orig_test $account_name $user_name $repeat_limit");
}else{
	print "perl ./prep_test_run_as_user.pl $orig_test $account_name $user_name\n";
	system("perl ./prep_test_run_as_user.pl $orig_test $account_name $user_name");
};
print "\n";

print "\n";
sleep(5);
print "\n";


###
### Run Test As User
###

print "\n";
print "++++++++++++++++++++++++++++++++++++ Running \"run_test_as_user.pl\" ++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";

print "\n";
if( $repeat_limit > 0){
	print "perl ./run_test_as_user.pl $orig_test $account_name $user_name $repeat_limit\n";
	system("perl ./run_test_as_user.pl $orig_test $account_name $user_name $repeat_limit");
}else{
	print "perl ./run_test_as_user.pl $orig_test $account_name $user_name\n";
	system("perl ./run_test_as_user.pl $orig_test $account_name $user_name");
};
print "\n";


###
### End of Script
###

print "\n";
print "[TEST_REPORT]\tPREP AND RUN TEST AS USER HAS BEEN COMPLETED\n";
print "\n";

exit(0);

1;


