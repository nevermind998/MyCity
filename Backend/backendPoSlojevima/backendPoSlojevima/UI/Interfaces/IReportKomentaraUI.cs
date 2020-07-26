using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.UI.Interfaces
{
    public interface IReportKomentaraUI
    {
        List<ReportKomentari> getAllReport();
        public void saveReport(ReportKomentari data);
        void deleteReportoveKomentaraByIdKomentara(long idKomentara);
        void deleteReportoveKomentaraByIdKorisnika(long idKorisnika);
        List<ReportKomentari> getReportoveKomentaraByIdKomentara(long idKomentara);
        long getBrojReportaByIdKomentara(long idKomentara);
        List<Korisnik> getKorisnikeKojiReportujuByIdKomentara(long idKomentar);
        List<ReportKomentari> getReportoveKomentaraByKorisnikId(long korisnik);
        long brojReportovaZaVlasnikaKomentara(long idKorisnika);
        int getReportKomentaraByIdKorisnika(long idKorisnika, long idKomentara);
        MinMaxReportova getMinIMaxBroj();

    }
}
