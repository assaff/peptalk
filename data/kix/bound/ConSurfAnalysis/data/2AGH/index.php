<?
    include ("/var/www/html/consurfdb/templates/header.tpl");
?>
				<h3>ConSurf Analysis for PDB 2AGH chain B </h3>
<ul><li><font color="red">Please note:</font> The PDB file contains more than one NMR structure. The first model is arbitrarily chosen in order to display the conservation grades using a protein viewer. (If you wish to display the results on a different model, create your own PDB file and cut all the ATOM records of the other models)</li></ul>
            <b>Alignment</b><br>
            &nbsp;&nbsp;&nbsp;The Sequences were collected from UNIPROT database using PSI-Blast algorithm<br>
            &nbsp;&nbsp;&nbsp;The number of Sequences used: 14<br>
            &nbsp;&nbsp;&nbsp;<A HREF= msa.aln>Multiple Sequence Alignment</A> (in Clustal format)<br><br>
            <b>Alignment details</b><br>
            &nbsp;&nbsp;&nbsp;Average pairwise distance: 1.33556<br>
            &nbsp;&nbsp;&nbsp;Lower bound: 0.11113<br>
            &nbsp;&nbsp;&nbsp;Upper bound: 2.64882<br>
            &nbsp;&nbsp;&nbsp;<font size=-1>The average number of replacements between any two sequences in the alignment; a distance of 0.01 means that on average, the expected replacement for every 100 positions is 1.</font><br>
            &nbsp;&nbsp;&nbsp;<a href=msa_aa_variety_percentage.csv>Residue variety per position in the MSA</a> <font size=-1>(The table is best viewed with an editor that respects Comma-Separated Values)</font><br>
            <br>
            <form enctype="multipart/form-data" action="/db_final.php" method="post" ><br>	
                <input type="submit" value="View ConSurf Results projected on the protein with FirstGlance in Jmol"><br>		  
                <input type=hidden name="pdb_ID" value =2AGH >
                <input type=hidden name="view_chain" value=fgij_B><br> 	
                
            <h4><u>Output Files:</u></h4>	
            &nbsp;&nbsp;&nbsp;<A HREF= consurf.grades>Amino Acid Conservation Scores, Confidence Intervals and Conservation Colors</A><br><br>
            <b>Sequences</b><br>
            &nbsp;&nbsp;&nbsp;<a href=seq_final.fasta>Unique Sequences Used</a> (displayed in FASTA format)<br>
            &nbsp;&nbsp;&nbsp;<A HREF= seq.blast.zip>PSI-BLAST output</A> (PSI-BLAST hits with E-values and pairwise alignments)<br><br>
            
            <b>Phylogenetic Tree</b><br>
            &nbsp;&nbsp;&nbsp;<A HREF=TheTree.txt>Phylogenetic Tree in Newick format</A><br><br>
            <b>RasMol Coloring Scripts</b><br>
&nbsp;&nbsp;&nbsp;<A HREF= isd_rasmol.scr>RasMol Coloring Script Showing Insufficient Data</A><br>
&nbsp;&nbsp;&nbsp;<A HREF= rasmol.scr>RasMol Coloring Script Hiding Insufficient Data</A><br>
<br /><br />
<a href = "ftp://ftp.consurfdb.tau.ac.il/2AGH/B">Download all files using ftp server</a><br /><br />
<br>
<br>
<?
    include("/var/www/html/consurfdb/templates/footer.tpl");
?>
