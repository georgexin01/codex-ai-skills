# Idealbuild sendEmail.php — Pure Reference Script

> Saved so you don't need the idealbuild folder anymore.
> This is the full working pattern. Adapt for each new project.

## Forms covered
- `contactForm` → type: `"contact"` → Sheet: `Contacts` | Fields: name, email, phone, message
- `speakWithUsForm` → type: `"speakWithUs"` → Sheet: `SpeakWithUs` | Fields: name, email, phone
- `careerForm` → type: `"jobApplication"` → Sheet: `JobApplication` | Fields: name, phone, email, position (input name=`pos`), file upload

## Full Script

```javascript
document.addEventListener('DOMContentLoaded', function() {

    let isSubmitting = false;

    const fetchCode = '{APPS_SCRIPT_DEPLOYMENT_ID}';

    async function fetchPostByType(type, data) {
        const postData = { type, data };
        try {
            let response = await fetch(
                `https://script.google.com/macros/s/${fetchCode}/exec`, {
                    method: "POST",
                    cache: "no-cache",
                    redirect: "follow",
                    body: JSON.stringify(postData),
                }
            );
            let result;
            const contentType = response.headers.get("content-type");
            if (contentType && contentType.includes("application/json")) {
                result = await response.json();
            } else {
                const text = await response.text();
                try { result = JSON.parse(text); }
                catch { result = (response.ok || response.type === 'opaque') ? { success: true } : (() => { throw new Error(text); })(); }
            }
            if (result.success === false) throw new Error(result.message || "Server error");
            return result;
        } catch (error) { throw error; }
    }

    function readFileAsBase64(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onload = () => resolve(reader.result);
            reader.onerror = reject;
            reader.readAsDataURL(file);
        });
    }

    function setButtonText(button, text) {
        if (button.tagName === 'INPUT') { button.value = text; }
        else { button.innerHTML = text; }
    }

    function handleSubmitUI(button, state, originalText, originalBg) {
        if (state === 'sending') {
            setButtonText(button, 'Sending..'); button.disabled = true;
        } else if (state === 'success') {
            setButtonText(button, 'Successfully Sent!');
            button.style.backgroundColor = '#28a745'; button.style.borderColor = '#28a745'; button.style.color = '#fff';
            setTimeout(() => { setButtonText(button, originalText); button.style.backgroundColor = originalBg; button.style.borderColor = originalBg; button.style.color = ''; button.disabled = false; isSubmitting = false; }, 3000);
        } else if (state === 'error') {
            setButtonText(button, 'Failed - Try Again');
            button.style.backgroundColor = '#dc3545'; button.style.borderColor = '#dc3545'; button.style.color = '#fff';
            setTimeout(() => { setButtonText(button, originalText); button.style.backgroundColor = originalBg; button.style.borderColor = originalBg; button.style.color = ''; button.disabled = false; isSubmitting = false; }, 3000);
        }
    }

    // CONTACT FORM — name, email, phone, message
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', async (event) => {
            event.preventDefault();
            if (isSubmitting) return; isSubmitting = true;
            const form = event.target;
            const button = form.querySelector('input[type="submit"], button[type="submit"]');
            const originalText = button.value || button.innerHTML;
            const originalBg = button.style.backgroundColor;
            handleSubmitUI(button, 'sending');
            const formData = new FormData(form);
            const contactData = { name: formData.get('name'), email: formData.get('email'), phone: formData.get('phone'), message: formData.get('message') };
            try {
                await fetchPostByType("contact", contactData);
                form.reset(); handleSubmitUI(button, 'success', originalText, originalBg);
            } catch (error) { handleSubmitUI(button, 'error', originalText, originalBg); }
        });
    }

    // SPEAK WITH US FORM — name, email, phone
    const speakWithUsForm = document.getElementById('speakWithUsForm');
    if (speakWithUsForm) {
        speakWithUsForm.addEventListener('submit', async (event) => {
            event.preventDefault();
            if (isSubmitting) return; isSubmitting = true;
            const form = event.target;
            const button = form.querySelector('input[type="submit"], button[type="submit"]');
            const originalText = button.value || button.innerHTML;
            const originalBg = button.style.backgroundColor;
            handleSubmitUI(button, 'sending');
            const formData = new FormData(form);
            const speakData = { name: formData.get('name'), email: formData.get('email'), phone: formData.get('phone') };
            try {
                await fetchPostByType("speakWithUs", speakData);
                form.reset(); handleSubmitUI(button, 'success', originalText, originalBg);
            } catch (error) { handleSubmitUI(button, 'error', originalText, originalBg); }
        });
    }

    // CAREER FORM — name, phone, email, pos (position), file upload
    const careerForm = document.getElementById('careerForm');
    if (careerForm) {
        careerForm.addEventListener('submit', async (event) => {
            event.preventDefault();
            if (isSubmitting) return; isSubmitting = true;
            const form = event.target;
            const button = form.querySelector('input[type="submit"], button[type="submit"]');
            const originalText = button.value || button.innerHTML;
            const originalBg = button.style.backgroundColor;
            handleSubmitUI(button, 'sending');
            const formData = new FormData(form);
            const fileInput = form.querySelector('input[type="file"]');
            let careerData = { name: formData.get('name'), phone: formData.get('phone'), email: formData.get('email'), position: formData.get('pos') };
            if (fileInput && fileInput.files.length > 0) {
                const file = fileInput.files[0];
                try {
                    careerData.fileData = await readFileAsBase64(file);
                    careerData.fileName = file.name;
                    careerData.fileType = file.type;
                } catch (fileError) { console.error("Error reading file:", fileError); }
            }
            try {
                await fetchPostByType("jobApplication", careerData);
                form.reset(); handleSubmitUI(button, 'success', originalText, originalBg);
            } catch (error) { handleSubmitUI(button, 'error', originalText, originalBg); }
        });
    }
});
```

## AppScript Tables this script writes to

| type | Sheet | Headers |
|---|---|---|
| `contact` | Contacts | Timestamp, Name, Email, Phone, Message |
| `speakWithUs` | SpeakWithUs | Timestamp, Name, Email, Phone |
| `jobApplication` | JobApplication | Timestamp, Name, Phone, Email, Position, Resume (Drive URL) |
| — | EmailAccount | Email (pre-existing, never recreate) |
