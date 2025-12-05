<?php
// SPDX-FileCopyrightText: 2025 Eli Array Minkoff
//
// SPDX-License-Identifier: 0BSD

// Echo back the user agent of the request, followed by a newline
// meant for testing ad-hoc command-line API clients, when required to include
// a specific user agent by automation policies.
echo $_SERVER['HTTP_USER_AGENT'];
echo '
';
?>
