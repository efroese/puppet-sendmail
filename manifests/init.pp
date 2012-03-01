#
# = Class: sendmail
# Install sendmail and configure it. Recofniguration triggers restart.
#
# == Parameters:
#
# $sendmail_mc_template:: A template to generate the sendmail.mc file.
#
# $submit_mc_template:: A template to generate the submit.mc file.
#
class sendmail (
    $sendmail_mc_template = undef,
    $submit_mc_template = undef
    ){

    package { [ 'sendmail', 'sendmail-cf', ] : ensure => installed }

    if $sendmail_mc_template != undef {
        file { "/etc/mail/sendmail.mc":
            mode    => 644,
            content => $sendmail_mc_template,
            notify  => Exec['sendmail-make-config'],
        }
    }

    if $submit_mc_template != undef {
        file { "/etc/mail/submit.mc":
            mode    => 644,
            content => $submit_mc_template,
            notify  => Exec['sendmail-make-config'],
        }
    }

    exec { 'sendmail-make-config':
        command     => "make -C /etc/mail",
        refreshonly => true,
        notify      => Service['sendmail'],
    }

    service { 'sendmail':
        ensure => running,
        hasstatus => true,
        enable => true,
    }
}
