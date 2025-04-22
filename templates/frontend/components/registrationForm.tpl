{**
 * templates/frontend/components/registrationForm.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the basic registration form fields
 *
 * @uses $locale string Locale key to use in the affiliate field
 * @uses $givenName string First name input entry if available
 * @uses $familyName string Last name input entry if available
 * @uses $countries array List of country options
 * @uses $country string The selected country if available
 * @uses $email string Email input entry if available
 * @uses $username string Username input entry if available
 *}
<script type="text/javascript">
	function selectAffiliation(event) {
		const affiliationInput = document.getElementById('affiliation');
		if (event.target.value === 'other') {
			for (let item of document.getElementsByClassName('affiliation-ror')) {
				item.style.display = 'initial';
			}
			affiliationInput.value = '';
			document.getElementById('organizations').innerHTML = '';
			document.getElementById('organizations-container').style.display = 'none';

			return;
		} else {
			for (let item of document.getElementsByClassName('affiliation-ror')) {
				item.style.display = 'none';
			}
		}

		affiliationInput.value = event.target.value;
	}

	function lookupOrganizations(event) {
		const organizationList = document.getElementById('organizations');
		const searchPhrase = event.target.value;
		if (searchPhrase.length <= 3) {
			return;
		}
		organizationList.innerHTML = '';

		fetch('https://api.ror.org/organizations?affiliation=' + searchPhrase + '*')
				.then(response => response.json())
				.then(data => {
					let organizations = new Map();
					let items = data.items;
					items.forEach((item) => {
						let row = {
							id: item.organization.id,
							name: item.organization.name
						};
						if (organizations.has(row.id)) {
							return;
						}
						organizations.set(row.id, row.name);
              {literal}
						organizationList.innerHTML += `<li style="max-width: 100%"><a onclick="selectOrganization('${row.name}')">${row.name} [${row.id}]</a></li>`;
              {/literal}
					});

					if (!organizationList.innerHTML) {
						document.getElementById('organizations-container').style.display = 'none';
					} else {
						document.getElementById('organizations-container').style.display = 'flex';
					}
				})
				.catch(error => console.log(error));
	}

	function selectOrganization(name) {
		document.getElementById('affiliation').value = name;
	}
</script>
<fieldset class="identity">
	<legend>
        {translate key="user.profile"}
	</legend>
	<div class="fields">
		<div class="given_name">
			<label>
				<span class="label">
					{translate key="user.givenName"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader">
						{translate key="common.required"}
					</span>
				</span>
				<input type="text" name="givenName" autocomplete="given-name" id="givenName"
				       value="{$givenName|default:""|escape}" maxlength="255" required aria-required="true">
			</label>
		</div>
		<div class="family_name">
			<label>
				<span class="label">
					{translate key="user.familyName"}
				</span>
				<input type="text" name="familyName" autocomplete="family-name" id="familyName"
				       value="{$familyName|default:""|escape}" maxlength="255">
			</label>
		</div>
		<div class="affiliation" style="display: flex; flex-direction: column; gap: 8px">
			<label>
				<span class="label">
					{translate key="user.affiliation"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader">
						{translate key="common.required"}
					</span>
				</span>
				<select onchange="selectAffiliation(event)" required aria-required="true">
					<option selected value=""></option>
					<option>Comenius University Bratislava</option>
					<option>Eötvös Loránd University</option>
					<option>University of Ljubljana</option>
					<option>University of Vienna</option>
					<option value="other">other (write below)</option>
				</select>
			</label>
			<label class="affiliation-ror" style="display: none">
				<span class="label">
					{translate key="plugins.generic.ror.input.lookup.label"}
				</span>
				<input type="text" aria-required="false" onkeyup="lookupOrganizations(event)"
				       title="{translate key="plugins.generic.ror.lookup.title"}">
			</label>
			<div id="organizations-container"
			     style="border: 1px solid var(--fbc-secondary-text); background: var(--fbc-light-gray); display: none">
				<ul id="organizations" style="display: flex; flex-direction: column"></ul>
			</div>
			<label class="affiliation-ror" style="display: none">
				<span class="label">
					{translate key="user.affiliation"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader">
						{translate key="common.required"}
					</span>
				</span>
				<input type="text" name="affiliation" autocomplete="organization" id="affiliation"
				       value="{$affiliation|default:""|escape}" required aria-required="true" readonly
				       aria-readonly="true" disabled aria-disabled="true">
			</label>
		</div>
		<div class="country">
			<label>
				<span class="label">
					{translate key="common.country"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader">
						{translate key="common.required"}
					</span>
				</span>
				<select name="country" id="country" autocomplete="country-name" required aria-required="true">
					<option></option>
                    {html_options options=$countries selected=$country}
				</select>
			</label>
		</div>
	</div>
</fieldset>

<fieldset class="login">
	<legend>
        {translate key="user.login"}
	</legend>
	<div class="fields">
		<div class="email">
			<label>
				<span class="label">
					{translate key="user.email"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader">
						{translate key="common.required"}
					</span>
				</span>
				<input type="email" name="email" id="email" value="{$email|default:""|escape}" maxlength="90" required
				       aria-required="true" autocomplete="email">
			</label>
		</div>
		<div class="username">
			<label>
				<span class="label">
					{translate key="user.username"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader">
						{translate key="common.required"}
					</span>
				</span>
				<input type="text" name="username" id="username" value="{$username|default:""|escape}" maxlength="32"
				       required aria-required="true" autocomplete="username">
			</label>
		</div>
		<div class="password">
			<label>
				<span class="label">
					{translate key="user.password"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader">
						{translate key="common.required"}
					</span>
				</span>
				<input type="password" name="password" id="password" password="true" maxlength="32" required
				       aria-required="true" autocomplete="new-password">
			</label>
		</div>
		<div class="password">
			<label>
				<span class="label">
					{translate key="user.repeatPassword"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader">
						{translate key="common.required"}
					</span>
				</span>
				<input type="password" name="password2" id="password2" password="true" maxlength="32" required
				       aria-required="true" autocomplete="new-password">
			</label>
		</div>
	</div>
</fieldset>
