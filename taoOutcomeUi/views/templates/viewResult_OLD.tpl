<?php
use oat\tao\helpers\Template;
?>
<link rel="stylesheet" type="text/css" href="<?= ROOT_URL ?>taoOutcomeUi/views/css/result.css" />
<link rel="stylesheet" type="text/css" href="<?= ROOT_URL ?>taoOutcomeUi/views/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="<?= ROOT_URL ?>taoOutcomeUi/views/css/font-awesome.css" />
<link rel="stylesheet" type="text/css" href="<?= ROOT_URL ?>taoOutcomeUi/views/css/style.css" />

<header class="section-header flex-container-full">
</header>
<div class="main-container flex-container-full">

    <div id="view-result">
        <div id="resultsViewTools">
            <div class="tile">
                <select class="result-filter">
                    <option  value="all" ><?=__('All collected variables')?></option>
                    <option  value="firstSubmitted" ><?=__('First submitted variables only')?></option>
                    <option  value="lastSubmitted" ><?=__('Last submitted variables only')?></option>
                </select>
                <label>
                    <input type="checkbox" name="class-filter" value="<?=\taoResultServer_models_classes_ResponseVariable::class?>">
                    <span class="icon-checkbox cross"></span>
                    <?=__('Responses')?>
                </label>
                <label>
                    <input type="checkbox" name="class-filter" value="<?=\taoResultServer_models_classes_OutcomeVariable::class?>">
                    <span class="icon-checkbox cross"></span>
                    <?=__('Grades')?>
                </label>
                <label>
                    <input type="checkbox" name="class-filter" value="<?=\taoResultServer_models_classes_TraceVariable::class?>">
                    <span class="icon-checkbox cross"></span>
                    <?=__('Traces')?>
                </label>
				<button class="btn-info small result-filter-btn"><?=__('Filter');?></button>
            </div>
        </div>
		
		<div>
            <strong>
            <span class="icon-test-taker"></span>
                <?=__('Test Taker')?>
            </strong>	
			<table border="1px solid black" width="30%">
				<tr><td width="30%"><?=__('Login')?></td><td><?= _dh(get_data('userLogin'))?></td></tr>
				<tr><td><?=__('Label')?></td><td><?= _dh(get_data('label')) ?></td></tr>
				<tr><td><?=__('Name')?></td><td><?= _dh(get_data('userLastName'))?> <?= _dh(get_data('userFirstName'))?></td></tr>
			</table>
		</div>
		<div><br/></div>	
		
		<div>
			<?php if(!empty(get_data("deliveryVariables"))):?>
			<table border="1px solid black" width="30%">
				<?php foreach (get_data("deliveryVariables") as $testVariable){
                ?>
				<tr><td width="30%"><?=__('テスト名')?></td><td><?= _dh(get_data('title'))?></td></tr>
				<tr><td><?=__('実施日')?></td><td><?=tao_helpers_Date::displayeDate(tao_helpers_Date::getTimeStamp($testVariable->getEpoch()), tao_helpers_Date::FORMAT_CUSTOM)?></td></tr>
				<tr>
					<td><?=__('得点')?></td>
					<?php 
							$score = 3; 
							$maxscore = 5;
							$percentage = ($score/$maxscore)*100;
							$percentage .= '%  (';
							$percentage .= $score;
							$percentage .= '点/';
							$percentage .= $maxscore;
							$percentage .= '点)';
					?>
					<td><?=$percentage;?></td>
				</tr>
				<?php
                }
                ?>
			</table>
            <?php endif;?>
		</div>
		<div><br/></div>	
		
		<div class="larget">
			<div class="container-fluid">
				<div class="row">
					<table class="table table-bordered " cellpadding="10">
						<h5><b>問題別結果</b></h5>
						<tr class="text-center">
							<th class="active w2"></th>
							<th class="active w10">セクション</th>
							<th class="active w8">問題名 </th>
							<th class="active w10">解答</th>
							<th class="active w12">解答プレビュー</th>
							<th class="active w8">正解</th>
							<th class="active w12">正解プレビュー </th>
							<th class="active w5">正誤 </th>
							<th class="active w7">得点</th>
							<th class="active w7">最大得点</th>
							<th class="active w7">解答時間</th>
						</tr>
						<?php  
							$num=1; 
							foreach (get_data('variables') as $item){ 
						?>
						<tr>
							<td class="active pdt10"><?=$num++;?></td>
							<td class="active">1年上 </td>
							<td class="active"><?= _dh($item['label']) ?></td>
							<!-- Response Variable list -->
							<?php foreach ($item[\taoResultServer_models_classes_ResponseVariable::class] as $variableIdentifier  => $observation){
								$variable = $observation["var"];
								$answer = $variable->getCandidateResponse();
							?>
							<td><?=$answer;?></td>
							<?php
								}
							?>
							<td>
								<a href="#" data-uri="<?=$item['uri']?>"  data-state="<?=htmlspecialchars($item['state'])?>" class="btn-info small preview" target="preview">
									<span class="icon-preview"></span><?=__('Preview')?>
								</a>
							</td>
							<td></td>
							<td>
								<a href="#" data-uri="<?=$item['uri']?>"  data-state="<?=htmlspecialchars($item['state'])?>" class="btn-info small preview" target="preview">
									<span class="icon-preview"></span><?=__('Preview')?>
								</a>
							</td>
							<td>
								<span class="rgt
								  <?php
									  switch ($observation['isCorrect']){
										  case "correct":{ ?> fa fa-circle-o <?php break;}
										  case "incorrect":{ ?>icon-result-nok<?php break;}
										  default: { ?>icon-not-evaluated<?php break;}
									  }
								  ?>">
								</span>
							</td>
							<?php if (isset($item[\taoResultServer_models_classes_OutcomeVariable::class])) { ?>
							<!-- Outcome Variable section list-->
							<?php
								foreach ($item[\taoResultServer_models_classes_OutcomeVariable::class] as $variableIdentifier  => $observation){
								$variable = $observation["var"];
								$score = $variable->getValue();
							?>
							<td><?=$score;?></td>
							<?php
									}
								}
							?>
							<!-- End of Outcome Variable List -->
						</tr>
						
						<?php } ?>
						<tr>
							<td colspan="7" style="border-left: 1px solid #fff;border-bottom: 1px solid #fff"></td>
							<td style="">合計 </td>
							<td>6点</td>
							<td>8点</td>
							<td>61秒</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		
		<div class="table3">
			<div class="container-fluid">
				<div class="row">
					<div class="col-md-6">
						<h5><b>セクション別結果</b></h5>
						<table class="table table-bordered">
							<tr  class="active">
								<td ></td>
								<td >セクション</td>
								<td >得点</td>
								<td>得点グラフ</td>
							</tr>
							<tr>
								<td class="active">1</td>
								<td class="active">1年上</td>
								<td>８６％（６点／７点)</td>
								<td class="success"></td>
							</tr>
							<tr>
								<td class="active">2</td>
								<td class="active">1年上</td>
								<td>0%(６点／７点)</td>
								<td class="active"></td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
		
<div id="form-container" >

    <?php if(get_data('errorMessage')):?>
    <fieldset class='ui-state-error'>
        <legend><strong><?=__('Error')?></strong></legend>
        <?=get_data('errorMessage')?>
    </fieldset>
    <?php endif?>

</div>

<script type="text/javascript">
    requirejs.config({
        config: {
            'taoOutcomeUi/controller/viewResult': {
                id: '<?=get_data("id")?>',
                classUri: '<?=get_data("classUri")?>',
                filterSubmission: '<?=get_data("filterSubmission")?>',
                filterTypes: '<?=json_encode(get_data("filterTypes"))?>',
            }
        }
    });
</script>

<?php
Template::inc('footer.tpl', 'tao');
?>
