import React, { useState } from "react";

const Register = () => {
  const [formData, setFormData] = useState({
    userName: "",
    firstName: "",
    lastName: "",
    email: "",
    password: ""
  });

  const handleChange = (event) => {
    setFormData({
      ...formData,
      [event.target.name]: event.target.value
    });
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    console.log("Register data:", formData);
  };

  return (
    <div className="register-container">
      <h1>Register / Inscription</h1>

      <form onSubmit={handleSubmit}>
        <label htmlFor="userName">Username / Nom d'utilisateur</label>
        <input id="userName" type="text" name="userName" placeholder="Username" value={formData.userName} onChange={handleChange} required />

        <label htmlFor="firstName">First Name / Prénom</label>
        <input id="firstName" type="text" name="firstName" placeholder="First Name" value={formData.firstName} onChange={handleChange} required />

        <label htmlFor="lastName">Last Name / Nom</label>
        <input id="lastName" type="text" name="lastName" placeholder="Last Name" value={formData.lastName} onChange={handleChange} required />

        <label htmlFor="email">Email / E-mail</label>
        <input id="email" type="email" name="email" placeholder="Email" value={formData.email} onChange={handleChange} required />

        <label htmlFor="password">Password / Mot de passe</label>
        <input id="password" type="password" name="password" placeholder="Password" value={formData.password} onChange={handleChange} required />

        <button type="submit">Register / S'inscrire</button>
      </form>
    </div>
  );
};

export default Register;
