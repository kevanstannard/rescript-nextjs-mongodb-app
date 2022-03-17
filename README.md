# ReScript NextJS MongoDB App

This is a basic ReScript NextJS MongoDB application template.

## Demo

You can view a demo at:

https://rescript-nextjs-mongodb-app.vercel.app/

## About this template

This template is based on the [ReScript NextJS Template](https://github.com/ryyppy/rescript-nextjs-template) and the [NextJS MongoDB App](https://github.com/hoangvvo/nextjs-mongodb-app) projects.

The template includes:

- [ReScript](https://rescript-lang.org) and [ReScript React](https://rescript-lang.org/docs/react/latest/introduction)
- [NextJS](https://nextjs.org/)
- [MongoDB](https://www.mongodb.com/)
- [Tailwind CSS](https://tailwindcss.com/)

It has simple account features such as signing up, logging in, and basic account management. It also includes [ReCaptcha](https://www.google.com/recaptcha/about/) and account related email notifications using [Send Grid](https://sendgrid.com/).

## Environment variables

For local development, copy the `.env.example` file to `.env` and provide the following environment variables.

| Variable                  | Description                                                     |
| ------------------------- | --------------------------------------------------------------- |
| APPLICATION_NAME          | Name of your application. Currently used in email messages.     |
| APPLICATION_URL           | URL of your hosted application. Used in email messages.         |
| APPLICATION_EMAIL_NAME    | Name to use in emails sent from the application.                |
| APPLICATION_EMAIL_ADDRESS | Email address to use in emails sent from the application.       |
| MONGODB_URI               | MongoDB connection string (including credentials and database). |
| SESSION_COOKIE_NAME       | Name of cookie for IronSession session management.              |
| SESSION_COOKIE_PASSWORD   | Password for cookie for IronSession session management.         |
| RECAPTCHA_SITE_KEY        | ReCaptcha site key.                                             |
| RECAPTCHA_SECRET_KEY      | ReCaptcha secret key.                                           |
| SENDGRID_API_KEY          | SendGrid API key (optional).                                    |

## Development

Run ReScript in dev mode:

```
npm run res:start
```

In another tab, run the Next dev server:

```
npm run dev
```
