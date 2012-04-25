#!/usr/bin/perl
use strict;
use Cwd;

$ENV{'EUCALYPTUS'} = "/opt/eucalyptus";

my $FAIL_LOG = "";

###
### check for arguments
###

my $given_test_name = "";
my $given_account_name = "";
my $given_user_name = "";
my $given_expect_name = "";

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
	$given_expect_name = shift @ARGV;
};


###
### check for testname, account, user, and repeat limit option
###

print "\n";
print "########################### GET ACCOUNT AND USER NAME  ##############################\n";

my $orig_test = "dan_test_dev_as_user";
my $account_name = "default-qa-account";
my $user_name = "user00";
my $expect_name = "";

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

if( $given_expect_name ne "" ){
	$expect_name = $given_expect_name;
};


my $testname = $orig_test . "_user_" . $user_name;

print "\n";
print "TEST NAME [$testname]\n";
print "TEST ACCOUNT NAME [$account_name]\n";
print "TEST USER NAME [$user_name]\n";
if( $expect_name ne "" ){
	print "EXPECT FILE NAME [$expect_name]\n";
};
print "\n";


my %expected_output = {};
if( $expect_name ne "" ){
	populate_expected_output_hash($expect_name);
};

#foreach my $key (keys %expected_output){
#	my $value = $expected_output{$key};
#	print "$key --> $value\n";
#};


###
### Check the logs of previous test run
###

print "\n";
print "++++++++++++++++++++++++++++++++++++ Checking Logs ++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";

my $log_dir = "../etc/runs/". $testname . "/artifacts";

if( !( -e $log_dir ) ){
	print "[TEST_REPORT]\tFAILED in locating log directory $log_dir !!\n\n";
	exit(1);
};

print "ls $log_dir\n";
print "\n";
my $this_ls = `ls $log_dir`;
chomp($this_ls);
print $this_ls ."\n";
print "\n";

print "\n";
print "\n";
print "\n";

my @log_array = split(" ", $this_ls);
foreach my $log (@log_array){
	chomp($log);
	print "LOG FILE:\n" . $log . "\n";
	print "\n";
	if( $log =~ /-stage-(\d+)/ ){
		if( $expect_name eq "" ){
			display_stages_only($log_dir . "/" . $log, $1);
		}else{
			analyze_stages($log_dir . "/" . $log, $1);
		};
	};
};

print "\n";
print "\n";
print "\n";

if( $expect_name ne "" && $FAIL_LOG ne ""){

print "\n";
print "####################### Fail Summary ########################\n";
print "\n";

print "\n";
chomp($FAIL_LOG);
print "$FAIL_LOG\n";

print "\n";
print "\n";
print "\n";

};

###
### End of Script
###

print "\n";
print "[TEST_REPORT]\tANALYZE LOGS AND REPORT HAS BEEN COMPLETED\n";
print "\n";

exit(0);


sub display_stages_only{
	my $this_log = shift @_;
	my $stage_id = shift @_;

	print "\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++ Display Stage [$stage_id] ++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "\n";

	if( $stage_id == 1 ){
		analyze_log_of_confirm_account_and_user($this_log, 0);
	}elsif( $stage_id == 2 ){
		analyze_log_of_confirm_list_ops($this_log, 0);
	}elsif( $stage_id == 3 ){
		analyze_log_of_confirm_create_ops($this_log, 0);
	}elsif( $stage_id == 4 ){
		analyze_log_of_confirm_add_ops($this_log, 0);
	}elsif( $stage_id == 5 ){
		analyze_log_of_confirm_delete_ops($this_log, 0);
	}else{
		return 1;
	};

	print "\n";
	print "\n";
	print "\n";

	return 0;
};

sub analyze_stages{
	my $this_log = shift @_;
	my $stage_id = shift @_;

	print "\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++ Analyze Stage [$stage_id] ++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "\n";

	if( $stage_id == 1 ){
		analyze_log_of_confirm_account_and_user($this_log, 1);
	}elsif( $stage_id == 2 ){
		analyze_log_of_confirm_list_ops($this_log, 1);
	}elsif( $stage_id == 3 ){
		analyze_log_of_confirm_create_ops($this_log, 1);
	}elsif( $stage_id == 4 ){
		analyze_log_of_confirm_add_ops($this_log, 1);
	}elsif( $stage_id == 5 ){
		analyze_log_of_confirm_delete_ops($this_log, 1);
	}else{
		return 1;
	};

	print "\n";
	print "\n";
	print "\n";

	return 0;
};


sub analyze_log_of_confirm_account_and_user{
	my $this_log = shift @_;
	my $is_compare = shift @_;

	print "\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "ANALYZE [CONFIRM_ACCOUNT_AND_USER]\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "\n";

	print "\n";
	system("cat $this_log | grep TEST_REPORT");
	print "\n";

	print "\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "END OF ANALYZE [CONFIRM_ACCOUNT_AND_USER]\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "\n";
	
	return 0;
};

sub analyze_log_of_confirm_list_ops{
	my $this_log = shift @_;
	my $is_compare = shift @_;

	print "\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "ANALYZE [CONFIRM_LIST_AND_OPS]\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "\n";

	if( $is_compare ){
		print "\n";
		compare_action_and_output($this_log, "list", "stage02");
		print "\n";
	}else{
		print "\n";
		display_action_and_output($this_log, "list");
		print "\n";
	};

	print "\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "END OF ANALYZE [CONFIRM_LIST_AND_OPS]\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "\n";
	
	return 0;
};

sub analyze_log_of_confirm_create_ops{
	my $this_log = shift @_;
	my $is_compare = shift @_;

	print "\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "ANALYZE [CONFIRM_CREATE_AND_OPS]\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "\n";

	if( $is_compare ){
		print "\n";
		compare_action_and_output($this_log, "create", "stage03");
		print "\n";

		print "\n";
		compare_action_and_output($this_log, "list", "stage03");
		print "\n";
	}else{

		print "\n";
		display_action_and_output($this_log, "create");
		print "\n";

		print "\n";
		display_action_and_output($this_log, "list");
		print "\n";
	};

	print "\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "END OF ANALYZE [CONFIRM_CREATE_AND_OPS]\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "\n";
	
	return 0;
};

sub analyze_log_of_confirm_add_ops{
	my $this_log = shift @_;
	my $is_compare = shift @_;
	
	print "\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "ANALYZE [CONFIRM_ADD_AND_OPS]\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "\n";

	if( $is_compare ){
		print "\n";
		compare_action_and_output($this_log, "add", "stage04");
		print "\n";

		print "\n";
		compare_action_and_output($this_log, "list", "stage04");
		print "\n";
	}else{
		print "\n";
		display_action_and_output($this_log, "add");
		print "\n";

		print "\n";
		display_action_and_output($this_log, "list");
		print "\n";
	};

	print "\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "END OF ANALYZE [CONFIRM_ADD_AND_OPS]\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "\n";

	return 0;
};

sub analyze_log_of_confirm_delete_ops{
	my $this_log = shift @_;
	my $is_compare = shift @_;

	print "\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "ANALYZE [CONFIRM_DELETE_AND_OPS]\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "\n";

	if( $is_compare ){
		print "\n";
		compare_action_and_output($this_log, "delete", "stage05");
		print "\n";

		print "\n";
		compare_action_and_output($this_log, "list", "stage05");
		print "\n";
	}else{
		print "\n";
		display_action_and_output($this_log, "delete");
		print "\n";

		print "\n";
		display_action_and_output($this_log, "list");
		print "\n";
	};

	print "\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "END OF ANALYZE [CONFIRM_DELETE_AND_OPS]\n";
	print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
	print "\n";

	return 0;
};



sub display_action_and_output{
	my $this_log = shift @_;
	my $prefix = shift @_;

	open( LIST, "< $this_log" ) or die $!;
	my $line;
	my $is_output = 0;
	my $output = "";
	while( $line = <LIST> ){
		chomp($line);
		if( $is_output && $line =~ /^\#\#\#END\#\#\#/ ){
			print "OUTPUT:\n";
			print $output . "\n";
			print "\n";
			$is_output = 0;
			$output = "";
		}elsif( $is_output ){
			$output .= $line . "\n";
		}elsif( $line =~ /^$prefix.+\:$/ ){
			print "ACTION:\n";
			print $line . "\n";
			print "\n";
			$is_output = 1;
		};
	};
	close(LIST); 
	return 0;
};

sub compare_action_and_output{
	my $this_log = shift @_;
	my $prefix = shift @_;
	my $stage = shift @_;

	open( LIST, "< $this_log" ) or die $!;
	my $line;
	my $is_output = 0;
	my $output = "";
	my $action = "";
	while( $line = <LIST> ){
		chomp($line);
		if( $is_output && $line =~ /^\#\#\#END\#\#\#/ ){
			print "OUTPUT:\n";
			print $output . "\n";
			print "\n";

			chomp($output);
			verify_output_to_expected($stage . "-" . $action, $output );

			$is_output = 0;
			$output = "";
			$action = "";
		}elsif( $is_output ){
			$output .= $line . "\n";
		}elsif( $line =~ /^$prefix.+\:$/ ){
			print "ACTION:\n";
			print $line . "\n";
			print "\n";
			$is_output = 1;
			$action = $line;
		};
	};
	close(LIST); 
	return 0;
};

sub verify_output_to_expected{
	my $action = shift @_;
	my $output = shift @_;

	my $expect = $expected_output{$action};
	

	if( $expect eq "" ){
		$FAIL_LOG .= "[TEST_REPORT]\tFAILED in getting expected output for the action \'$action\' !!\n\n";
		print "[TEST_REPORT]\tFAILED in getting expected output for the action \'$action\' !!\n\n";
		return 1;
	};

	chomp($output);	

	### Special Case
	if( $expect eq "::NULL::" ){
		if( $output ne "" ){
			$FAIL_LOG .= "[TEST_REPORT]\tFAILED in matching the expected output\n";
			$FAIL_LOG .= "[TEST_REPORT]\tFAILED Action = \'$action\'\n";
			$FAIL_LOG .= "[TEST_REPORT]\tFAILED Expect = \'$expect\'\n";
			$FAIL_LOG .= "[TEST_REPORT]\tFAILED Output = \'$output\'\n";
			$FAIL_LOG .= "\n";

			print "[TEST_REPORT]\tFAILED in matching the expected output\n";
			print "[TEST_REPORT]\tFAILED Action = \'$action\'\n";
			print "[TEST_REPORT]\tFAILED Expect = \'$expect\'\n";
			print "[TEST_REPORT]\tFAILED Output = \'$output\'\n";
			print "\n";
			return 1;
		}else{
			return 0;
		};
	};

	my @exp_array = split(" ", $expect);
	foreach my $exp (@exp_array){
		if( !( $output =~ /$exp/ ) ){
			$FAIL_LOG .= "[TEST_REPORT]\tFAILED in matching the expected output\n";
			$FAIL_LOG .= "[TEST_REPORT]\tFAILED Action = \'$action\'\n";
			$FAIL_LOG .= "[TEST_REPORT]\tFAILED Expect = \'$expect\'\n";
			$FAIL_LOG .= "[TEST_REPORT]\tFAILED Output = \'$output\'\n";
			$FAIL_LOG .= "\n";

			print "[TEST_REPORT]\tFAILED in matching the expected output\n";
			print "[TEST_REPORT]\tFAILED Action = \'$action\'\n";
			print "[TEST_REPORT]\tFAILED Expect = \'$expect\'\n";
			print "[TEST_REPORT]\tFAILED Output = \'$output\'\n";
			print "\n";
			return 1;			
		};
	};
	return 0;
};


sub populate_expected_output_hash{
	my $file_prefix = shift @_;

	for( my $i = 2; $i<= 5; $i++ ){
		my $this_stage = "stage" . sprintf("%02d", $i);
		my $this_log = $file_prefix . "-" . $this_stage . ".expected";
		if( !( -e "./$this_log") ){
			print "[TEST_REPORT]\tFAILED in locating $this_log !!\n\n";
			exit(1);
		};
		open( LIST, "< $this_log" ) or die $!;
		my $line;
		my $is_expect = 0;
		my $is_action = 0;
		my $action = "";
		my $expect = "";
		while( $line = <LIST> ){
			chomp($line);
			if( $is_action ){
				$action = $line;
				$is_action = 0;
			}elsif( $is_expect ){
				$expect = $line;
				$is_expect = 0;
				my $key = $this_stage . "-" . $action;
				my $value = $expect;
				$expected_output{$key} = $value;
#				print "$key --> $value\n";
			}elsif( $line =~ /^ACTION:/ ){
				$is_action = 1;
			}elsif( $line =~ /^EXPECT:/ ){
				$is_expect = 1;
			};
		};
		close(LIST); 

	};
	return 0;
};

1;


