const express = require('express');
const passport = require('passport');
const router = express.Router();

router.get('/google', passport.authenticate('google', { scope: ['profile', 'email'] }));

router.get('/google/callback', passport.authenticate('google', {
  successRedirect: '/auth/success',
  failureRedirect: '/auth/failure'
}));

router.get('/success', (req, res) => {
  res.json({ user: req.user });
});

router.get('/failure', (req, res) => {
  res.status(401).send('Login Failed');
});

module.exports = router;
