use strict;
use warnings;
use Test::More 'no_plan';
use Test::Mojo;
use Data::Dumper;

use lib "./lib";
use_ok ('Regulome');

use_ok("Regulome::SnpDB");
use_ok("Regulome::RDB"); # for check_coord

my $sampleRange = {  # 1 based coordinates
	# note: fake data
'chr1:100001100..100001500'	=> [
          [
            'chr1',
            100001200
          ],
          [
            'chr1',
            100001232
          ],
          [
            'chr1',
            100001265
          ],
          [
            'chr1',
            100001482
          ]
        ],
'4:36190..36270' => [ # edge effect tests
          [
            'chr4',
            36203
          ],
          [
            'chr4',
            36238
          ],
          [
            'chr4',
            36264
          ],
	],
'4:36190..36265' =>  [
          [
            'chr4',
            36203
          ],
          [
            'chr4',
            36238
          ],
          [
            'chr4',
            36264
          ],
	],	
'4:36190..36264' => [
          [
            'chr4',
            36203
          ],
          [
            'chr4',
            36238
          ],
	],	
'4:36202..36204' => [
		[
			'chr4',
			36203
		]
	],	
'4:36202..36203' => [
	],	
};

my $sampleGFFrange = {
	# note: fake data
'chr6	user	      feature	138022520	138023100	.		+	0	PMID=1656391'
	=> [ [
            'chr6',
            138022519
          ],
          [
            'chr6',
            138022539
          ],
          [
            'chr6',
            138022622
          ],
          [
            'chr6',
            138022645
          ],
          [
            'chr6',
            138022803
          ],
          [
            'chr6',
            138022872
          ],
          [
            'chr6',
            138023047
          ],
          [
            'chr6',
            138023093
          ],
],
'chr4	user 	feature	36190	36270	.		+	0	PMID=1656391' => [ # edge effect tests
          [
            'chr4',
            36203
          ],
          [
            'chr4',
            36238
          ],
          [
            'chr4',
            36264
          ],
	],
'chr4	user	range	36190	36265	.		+	0	PMID=1656391' =>  [
          [
            'chr4',
            36203
          ],
          [
            'chr4',
            36238
          ],
          [
            'chr4',
            36264
          ],
	],	
'chr4	input	site	36190	36264	.		+	0	PMID=1656391' => [
          [
            'chr4',
            36203
          ],
          [
            'chr4',
            36238
          ],
	],	
'chr4	user	snp	36202	36204	.		+	0	PMID=1656391' => [
		[
			'chr4',
			36203
		]
	],	
'chr4	user	nada	36202	36203	.		+	0	PMID=1656391' => [
	],	

};

my $sampleBEDrange = {
'chr10	61004	70000	some	random	stuff	rs1938812' => [
          [
            'chr10',
            61019
          ],
          [
            'chr10',
            68239
          ],
          [
            'chr10',
            68490
          ],
          [
            'chr10',
            68574
          ],
          [
            'chr10',
            68812
          ]
],
'chr4	36189	36270' => [ # edge effect tests
          [
            'chr4',
            36203
          ],
          [
            'chr4',
            36238
          ],
          [
            'chr4',
            36264
          ],
	],
'chr4	36189	36265	blad' =>  [
          [
            'chr4',
            36203
          ],
          [
            'chr4',
            36238
          ],
          [
            'chr4',
            36264
          ],
	],	
'chr4	36189	36264' => [
          [
            'chr4',
            36203
          ],
          [
            'chr4',
            36238
          ],
	],	
'chr4	36201	36204' => [
		[
			'chr4',
			36203
		]
	],	
'chr4	36201	36203' => [
	],	

};

my $allTest = {rs55998931 => ['chr1','10491']};
my $commonTest = { 
	rs11703994 => [ 'chr22', 16053790],
#	rs28675701 => ['chrX','60592'] some issue with sex chromosomes?
};

my $snpResult = { rs55998931 => [
          [
            10400,
            10550,
            395,
            395,
            'Histone_Modification',
            'ChIP-seq',
            'H3k4me3',
            'Hvmf',
            '',
            'NCP000'
          ],
          [
            10400,
            10550,
            395,
            395,
            'Histone_Modification',
            'ChIP-seq',
            'H3k4me3',
            'Hvmf',
            '',
            'NCP000'
          ],
          [
            10420,
            10570,
            10,
            10,
            'Chromatin_Structure',
            'DNase-seq',
            '',
            'Be2c',
            '',
            'NCP000'
          ],
          [
            10440,
            10590,
            77,
            77,
            'Chromatin_Structure',
            'DNase-seq',
            '',
            'Hvmf',
            '',
            'NCP000'
          ],
          [
            10440,
            10590,
            79,
            79,
            'Chromatin_Structure',
            'DNase-seq',
            '',
            'Jurkat',
            '',
            'NCP000'
          ],
          [
            10440,
            10590,
            89,
            89,
            'Chromatin_Structure',
            'DNase-seq',
            '',
            'Nb4',
            '',
            'NCP000'
          ],
          [
            10020,
            10775,
            168,
            168,
            'Histone_Modification',
            'ChIP-seq',
            'H3k09me3',
            'Dnd41',
            '',
            'NCP000'
          ],
          [
            10064,
            10667,
            148,
            148,
            'Histone_Modification',
            'ChIP-seq',
            'H3k09me3',
            'Nt2d1',
            '',
            'NCP000'
          ],
          [
            10139,
            10530,
            303,
            303,
            'Histone_Modification',
            'ChIP-seq',
            'H4k20me1',
            'Nhdfad',
            '',
            'NCP000'
          ],
          [
            10332,
            10536,
            66103,
            66103,
            'Protein_Binding',
            'ChIP-seq',
            'TAF7',
            'H1-hESC',
            '',
            'NCP000'
          ],
          [
            10382,
            10578,
            66139,
            66139,
            'Protein_Binding',
            'ChIP-seq',
            'ZBTB33',
            'HepG2',
            '',
            'NCP000'
          ]
        ]
};

my $snpdb = Regulome::SnpDB->new({ type=>'single', 
					 	           dbfile_all=>'./data/SnpDB/dbSNP132.db',
						           dbfile_common =>'./data/SnpDB/dbSNP132Common.db'});
isa_ok($snpdb,'Regulome::SnpDB');

while (my ($snpid, $c) = each (%$commonTest)) {
	is($snpdb->getRsid($c), $snpid,  "check comon getRsid");
	is_deeply($snpdb->getSNPbyRsid($snpid), $c, "check common getSNPbyRsid");
	my $sth = $snpdb->dbs->{common}->prepare("select chrom, position from data where rsid = ?");
	$sth->execute($snpid);
	my $res = $sth->fetchall_arrayref;
	is_deeply($res, [ $c ], "Sanity check of commonSNP db");
}

my ($format, $chk) = ('',[]);

my $r = Test::Mojo->new('Regulome')->app();
my $cntrl = Regulome::RDB->new(app => $r);
isa_ok($cntrl, 'Regulome::RDB');
while (my ($snpid, $c) = each (%$allTest)) {
	is($snpdb->getRsid($c), $snpid,  "check all getRsid");
	my $snp = $snpdb->getSNPbyRsid($snpid);
	is_deeply($snp, $c, "check all getSNPbyRsid");
	($format, $chk) = $cntrl->check_coord($snpid);
	is(scalar(@$chk),1,"Only 1 coord returned for SNP");
	my $scan = $r->rdb->process($chk->[0]);
	#use Data::Dumper;
	#print Dumper $scan;
	is_deeply($scan, $snpResult->{$snpid},"check SNP result");
}

# check_coord with a range checks SnpDB::getSNPbyRange()
=pod
## Generic 1-based input no longer accepted ##

for my $rng (keys %$sampleRange) {
	($format, $chk) = $cntrl->check_coord($rng);
	is($format, 'Generic - 1 Based', "check format (generic range)");
	is_deeply($chk, $sampleRange->{$rng}, "Check Generic range -> SNP ($rng)");
}
=cut
for my $gff (keys %$sampleGFFrange) {
	($format, $chk) = $cntrl->check_coord($gff);
	is($format, 'GFF - 1 Based', "check format (gff range)");
	is_deeply($chk, $sampleGFFrange->{$gff}, "Check GFF range -> SNP ($gff)");	
}

for my $bed (keys %$sampleBEDrange) {
	($format, $chk) = $cntrl->check_coord($bed);
	is($format, 'BED - 0 Based', "check format (BED range)");
	is_deeply($chk, $sampleBEDrange->{$bed}, "Check BED range -> SNP ($bed)");	
}

#TODO Unit tests for data in an example or two.
