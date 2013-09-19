#!/usr/bin/perl

# use module
use XML::Simple;
use Data::Dumper;
use strict;
use warnings;

our %pubmed_data;
our %word_data;
# create object
my $xml = new XML::Simple (KeyAttr=>[]);

my $data = $xml->XMLin("data2.txt");
my ($key1, $value1, @key_array);
my $xml_file;
open $xml_file, '>', 'data2.txt'
    or die "can't open $!";
#dereference hash ref
#
print $data->{MedlineCitation}->{PMID}->{content}, "\n";

traverse( $data );
print "\n------------------------------------------------\n";

foreach (sort keys %pubmed_data ){
    
    print "key = $_\n";
    print "value = $pubmed_data{$_}\n";
    $key1 = $_;
    $key1=~ s/!\s+//;
    $value1 = $pubmed_data{$_};
    @key_array = split(/\s+/, $key1);
    foreach (@key_array) {
        if (exists $word_data{$_} ) {
            $word_data{$_}++;
            
            }
        else {
            $word_data{$_} = $value1;
            }
        
        }
    
    }

foreach (sort keys %word_data ){
    print $xml_file "key = $_\n";
    print $xml_file "value = $word_data{$_}\n";
    
    
   }
close $xml_file;

sub traverse {
    our %pubmed_data;
    my ($element) = @_;
    if( ref( $element ) =~ /HASH/ ) {
        foreach my $key (keys %$element) {
  #          print "key=$key\n";
            next if ($key eq "PubmedData");
            traverse( $$element{$key} );
            }
    } 
    elsif( ref( $element)  =~ /ARRAY/ )  {
        #my $i = $_[0];
        traverse( $_ ) foreach @$element;
    } 
    else {
   #     print "$element\n";
        if (exists $pubmed_data{$element} ) {
            $pubmed_data{$element}++;
            
            }
        else {
            $pubmed_data{$element} = 1;
            }
    }
}