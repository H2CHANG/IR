#!/usr/bin/perl

# use module
use XML::Simple;
use Data::Dumper;
use strict;
use warnings;

our %pubmed_data;
# create object
my $xml = new XML::Simple (KeyAttr=>[]);

my 	$data = $xml->XMLin("data.txt");

#dereference hash ref
#
print $data->{MedlineCitation}->{PMID}->{content}, "\n";

traverse( $data );
print "\n------------------------------------------------\n";

foreach (sort keys %pubmed_data ){
    
    print "key = $_\n";
    print "value = $pubmed_data{$_}\n";
    
    
    }

sub traverse {
    our %pubmed_data;
    my ($element) = @_;
    if( ref( $element ) =~ /HASH/ ) {
        foreach my $key (keys %$element) {
            print "key=$key\n";
            next if ($key eq "PubmedData");
            traverse( $$element{$key} );
            }
    } 
    elsif( ref( $element)  =~ /ARRAY/ )  {
        #my $i = $_[0];
        traverse( $_ ) foreach @$element;
    } 
    else {
        print "$element\n";
        if (exists $pubmed_data{$element} ) {
            $pubmed_data{$element}++;
            
            }
        else {
            $pubmed_data{$element} = 1;
            }
    }
}