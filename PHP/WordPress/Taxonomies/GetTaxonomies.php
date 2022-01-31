<?php
////////////////////////////////////////
/// GET SELECTED TAXONOMY TERMS
////////////////////////////////////////
$term_array = array();
$term_list = wp_get_post_terms($post->ID, 'property_temporada', array("fields" => "all")); // property_temporada es el slug de la taxonomia
foreach($term_list as $term_single) {
    $term_array[] = $term_single;
}

////////////////////////////////////////
/// GET SELECTED TAXONOMY TERMS AND  ADVANCED CUSTOM FIELDS
////////////////////////////////////////
$term_array = array();
$term_list = wp_get_post_terms($post->ID, 'property_temporada', array("fields" => "all"));
foreach($term_list as $term_single) {
    $term_array[] = $term_single->name ; //do something here
    write_to_console($term_single);
    # Advanced custom fields
    $inicioTemporada = get_field('inicio_de_la_temporada', $term_single);
    $finTemporada = get_field('fin_de_la_temporada', $term_single);
    write_to_console("$inicioTemporada - $finTemporada");
}

////////////////////////////////////////
/// GET MULTIPLE TAXONOMIES
////////////////////////////////////////

$terms = wp_get_post_terms( $query->post->ID, array( 'country', 'subject' ) );
foreach ( $terms as $term ) :?>
    <p>
        <?php echo $term->taxonomy; ?>: <?php echo $term->name; ?>
    </p>
<?php endforeach;

#### Output:
#Country: United Kingdom
#Subject: Biology
#Subject: Chemistry
#Subject: Neurology

?>