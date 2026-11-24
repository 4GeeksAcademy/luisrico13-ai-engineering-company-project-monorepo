const form = document.querySelector('#contact-form');
const statusMessage = document.querySelector('#form-status');
const fields = {
  fullName: document.querySelector('#full-name'),
  email: document.querySelector('#email'),
  country: document.querySelector('#country'),
  phone: document.querySelector('#phone'),
  message: document.querySelector('#message'),
};

const validators = {
  fullName(value) {
    const name = value.trim();
    if (!name) return 'Escribe tu nombre completo.';
    if (name.length < 2) return 'El nombre debe tener al menos 2 caracteres.';
    return '';
  },
  email(value) {
    const email = value.trim();
    if (!email) return 'Escribe tu correo electrónico.';
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(email)) return 'Ingresa un correo válido, por ejemplo nombre@dominio.com.';
    return '';
  },
  country(value) {
    if (!value) return 'Selecciona Colombia o Estados Unidos.';
    return '';
  },
  phone(value) {
    const phone = value.trim();
    if (!phone) return '';
    if (!/^\+?[0-9][0-9\s().-]{6,28}$/.test(phone)) return 'Revisa el teléfono e incluye solo números y separadores habituales.';
    return '';
  },
  message(value) {
    const message = value.trim();
    if (!message) return 'Escribe un mensaje para continuar.';
    if (message.length < 20) return 'Tu mensaje debe tener al menos 20 caracteres.';
    return '';
  },
};

function showFieldError(field, message) {
  const error = document.querySelector(`#${field.id}-error`);
  field.setAttribute('aria-invalid', message ? 'true' : 'false');
  error.textContent = message;
  error.classList.toggle('hidden', !message);
  return !message;
}

function validateField(name) {
  const field = fields[name];
  return showFieldError(field, validators[name](field.value));
}

function clearStatus() {
  statusMessage.textContent = '';
  statusMessage.className = 'hidden rounded-xl p-4 text-sm font-medium';
}

for (const [name, field] of Object.entries(fields)) {
  field.addEventListener('input', () => {
    clearStatus();
    if (field.getAttribute('aria-invalid') === 'true') validateField(name);
  });
  field.addEventListener('change', () => {
    clearStatus();
    if (field.getAttribute('aria-invalid') === 'true') validateField(name);
  });
}

form.addEventListener('submit', (event) => {
  event.preventDefault();
  clearStatus();

  const isValid = Object.keys(fields).map(validateField).every(Boolean);
  if (!isValid) {
    const firstInvalidField = form.querySelector('[aria-invalid="true"]');
    firstInvalidField?.focus();
    statusMessage.textContent = 'Hay campos por revisar. Corrige los mensajes indicados y vuelve a intentarlo.';
    statusMessage.className = 'rounded-xl bg-red-50 p-4 text-sm font-medium text-red-800';
    return;
  }

  statusMessage.textContent = '¡Gracias por escribirnos! Tus datos pasaron la validación. Esta demostración no envía ni almacena el mensaje.';
  statusMessage.className = 'rounded-xl bg-green-50 p-4 text-sm font-medium text-green-900';
  statusMessage.focus();
  form.reset();
  for (const field of Object.values(fields)) field.removeAttribute('aria-invalid');
});

document.querySelector('#year').textContent = new Date().getFullYear();
