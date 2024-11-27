const apiBaseUrl = 'http://198.58.103.58:5001';

// Submit a prayer
document.getElementById('submitButton').addEventListener('click', () => {
	const prayerText = document.getElementById('prayerInput').value;
	const agreedToTerms = document.getElementById('termsCheckbox').checked;

	if (!prayerText) {
		alert('Please enter a prayer!');
		return;
	}

	if (!agreedToTerms) {
		alert('You must agree to the sacred terms!');
		return;
	}

	const data = {
		text: prayerText,
		agreed_to_terms: agreedToTerms
	};

	fetch(`${apiBaseUrl}/submit-prayer`, {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json',
		},
		body: JSON.stringify(data),
	})
	.then(response => response.json())
	.then(data => {
		alert(data.message || 'Prayer submitted successfully!');
		document.getElementById('prayerInput').value = '';
		document.getElementById('termsCheckbox').checked = false;
	})
	.catch(error => {
		console.error('Error:', error);
		alert('Failed to submit the prayer.');
	});
});

// Fetch recent prayers
document.getElementById('fetchButton').addEventListener('click', () => {
	const limit = prompt('How many prayers would you like to fetch?', '5') || '5';

	fetch(`${apiBaseUrl}/get-prayers?limit=${limit}`)
	.then(response => response.json())
	.then(data => {
		const prayersContainer = document.getElementById('prayersContainer');
		prayersContainer.innerHTML = '';
		data.forEach(prayer => {
			const listItem = document.createElement('li');
			listItem.textContent = `${prayer.text}`;
			prayersContainer.appendChild(listItem);
		});
	})
	.catch(error => {
		console.error('Error:', error);
		alert('Failed to fetch prayers.');
	});
});