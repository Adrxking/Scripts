<?php
//////////////////////////////////
// CALCULATOR FOR HOUSE BORROWING
//////////////////////////////////
# Get property price
$price           =   floatval(get_post_meta($post->ID, 'property_price', true));

# property_status has "For Sale", "Sold"
# Get the taxonomy name
foreach ($property_status as $key => $term) {
    # Check if its for sale
    if (($term->name) == "FOR SALE") { ?>
        <div class="_property_info">

            <!-- Box with standard price without borrowing --> 
            <div class="_standard_price_box">
                <h4>Costing Breakdown</h4>
                <div class="_standard_payment">
                    <h5>Standard form of payment</h5>
                    <p class="_standard_payment_title">Reservation deposit</p>
                    <p class="_standard_payment_price">3000€</p>
                    <p class="_standard_payment_title">Final payment</p>
                    <p class="_standard_payment_price"><?php print wp_kses_post(number_format($price - 3000)); ?>€</p>
                </div>
                <div class="_standard_payment">
                    <h5>Property purchase expenses</h5>
                    <p class="_standard_payment_title">Property price</p>
                    <p class="_standard_payment_price"><?php print wp_kses_post(number_format($price)); ?>€</p>
                    <p class="_standard_payment_title">Transfer Tax 7%</p>
                    <p class="_standard_payment_price"><?php print wp_kses_post(number_format($price * 7 / 100)); ?>€</p>
                    <p class="_standard_payment_title">Notary fees &#40;approx&#41;</p>
                    <p class="_standard_payment_price">600€</p>
                    <p class="_standard_payment_title">Land registry fees &#40;approx&#41;</p>
                    <p class="_standard_payment_price">600€</p>
                    <p class="_standard_payment_title">Legal fees &#40;approx&#41;</p>
                    <p class="_standard_payment_price">1,500€</p>
                </div>
            </div>

            <!-- Box with borrowing price calculator --> 
            <div class="_price_calculator_box">
                <?php
                $deposit        = $_POST['deposit'];
                $intRatePercent = $_POST['intrate'];
                $intRate        = ($intRatePercent / 100);
                $monthIntRate   = ($intRate / 12);
                $period         = $_POST['period'];
                $months         = ($period * 12);
                $priceMortaged  = ($price - $deposit);
                $pricePerMonth  = ($priceMortaged * ($monthIntRate * ($monthIntRate + 1) ** $months) / ((1 + $monthIntRate) ** $months - 1));
                $MortageCost    = ($months * $pricePerMonth);
                $intPay         = ($MortageCost - $priceMortaged);
                $monthIntPay    = ($intPay / $months);
                $totalCost      = ($MortageCost + $deposit);
                ?>

                <form action="" method="post" class="calculator">
                    <h4 class="_calc_title">Amount to borrow: <?php print wp_kses_post(number_format($price)); ?>€</h4>
                    <label class="_calc">Deposit &#40;&euro;&#41;</label>
                    <input class="_calc" type="text" name="deposit" maxlength="9" /><br />
                    <label class="_calc">Interest Rate &#40;&#37;&#41;</label>
                    <input class="_calc" type="text" name="intrate" maxlength="4" /><br />
                    <label class="_calc">Period &#40;Years&#41;</label>
                    <input class="_calc" type="text" name="period" maxlength="2" /><br />
                    <input type="submit" name="submit_calculator" value="Calculate" />
                </form>

                <?php
                if (isset($_POST['submit_calculator']))
                    echo "<h5 class='_calc_header'>Results</h5>";
                if (isset($_POST['submit_calculator']))
                    echo "<p class='_calc_result_title'>Mortage amount:&nbsp;</p><p class='_calc_result_price'>", number_format($priceMortaged), "€</p>";
                if (isset($_POST['submit_calculator']))
                    echo "<p class='_calc_result_title'>Total per month:&nbsp;</p><p class='_calc_result_price'>", number_format($pricePerMonth, 2), "€</p>";
                if (isset($_POST['submit_calculator']))
                    echo "<p class='_calc_result_title'>Interest Only per month:&nbsp;</p><p class='_calc_result_price'>", number_format($monthIntPay, 2), "€</p>";
                if (isset($_POST['submit_calculator']))
                    echo "<p class='_calc_result_title'>Total interest paid:&nbsp;</p><p class='_calc_result_price'>", number_format($intPay, 2), "€</p>";
                if (isset($_POST['submit_calculator']))
                    echo "<p class='_calc_result_title'>Total mortage cost:&nbsp;</p><p class='_calc_result_price'>", number_format($MortageCost, 2), "€</p>";
                if (isset($_POST['submit_calculator']))
                    echo "<p class='_calc_result_title'>Total cost:&nbsp;</p><p class='_calc_result_price'>", number_format($totalCost, 2), "€</p>";
                ?>

            </div>

        </div>
    <?php }
}