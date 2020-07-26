using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL.Interfaces
{
    public interface IReportKomentaraBL
    {
        List<ReportKomentari> getAllReport();
        public void saveReport(ReportKomentari data);
        void deleteReportoveKomentaraByIdKomentara(long idKomentara);
        void deleteReportoveKomentaraByIdKorisnika(long idKorisnika);
        List<ReportKomentari> getReportoveKomentaraByIdKomentara(long idKomentara);
        long getBrojReportaByIdKomentara(long idKomentara);
        List<ReportKomentari> getReportoveKomentaraByKorisnikId(long koirsnik);
        List<Korisnik> getKorisnikeKojiReportujuByIdKomentara(long idKomentara);
        long brojReportovaZaVlasnikaKomentara(long idKorisnika);
        int getReportKomentaraByIdKorisnika(long idKorisnika, long idKomentara);
        long maxReportova();

    }
}
