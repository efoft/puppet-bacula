Facter.add(:bacula_version) do
  confine :kernel => :Linux
  setcode do
    version = Facter::Util::Resolution.exec('/bin/rpm -q --queryformat "%{VERSION}-%{RELEASE}" bacula-common')
    if version
      version.match(/\d+\.\d+\.\d+/).to_s
    else
      nil
    end
  end
end
